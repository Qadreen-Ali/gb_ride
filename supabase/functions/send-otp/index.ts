// supabase/functions/send-otp/index.ts
import { serve } from "std/http/server.ts";
import { createClient } from "supabase-js";

/* ---------- env ---------- */
const env = {
  GETOTP_KEY     : Deno.env.get("GETOTP_API_KEY")!,
  GETOTP_SENDER  : Deno.env.get("GETOTP_SENDER_ID")!,
  GETOTP_TMPL    : Deno.env.get("GETOTP_TEMPLATE_ID")!,
  SB_URL         : Deno.env.get("SUPABASE_URL")!,
  SB_SERVICE_KEY : Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
};
(() => {
  const missing = Object.entries(env)
                       .filter(([,v]) => !v)
                       .map(([k]) => k);
  if (missing.length) throw `Missing env: ${missing.join(", ")}`;
})();

/* ---------- helpers ---------- */
const sb = createClient(env.SB_URL, env.SB_SERVICE_KEY);
const hash = (s: string) => btoa(s);
// const otp  = () => Math.floor(100_000 + Math.random() * 900_000).toString();
const fiveMin = () => new Date(Date.now() + 5 * 60 * 1000).toISOString();

/* ---------- core ---------- */
// async function sendSMS(phone: string, code: string) {
//   const res = await fetch("https://api.otp.dev/v1/verifications", {
//     method : "POST",
//     headers: {
//       "X-OTP-Key" : env.GETOTP_KEY,
//       "accept"    : "application/json",
//       "content-type": "application/json",
//     },
//     body: JSON.stringify({
//       data: {
//         channel : "sms",
//         sender  : env.GETOTP_SENDER,
//         phone   : phone.replace(/\D/g, ""),
//         template: env.GETOTP_TMPL,
//         code_length: 6,
//       },
//     }),
//   });
//   if (!res.ok) {
//     const txt = await res.text();
//     throw `GetOTP: ${txt}`;
//   }
// }

async function saveCode(phone: string, code: string) {
  await sb.from("otp_verifications").delete().eq("phone", phone);
  const { error } = await sb.from("otp_verifications").insert({
    phone,
    otp_hash  : hash(code),
    expires_at: fiveMin(),
  });
  if (error) throw `DB: ${error.message}`;
}

/* ---------- handler ---------- */
serve(async (req) => {
  // CORS
  const headers: Record<string, string> = {
    "Content-Type" : "application/json",
    "Access-Control-Allow-Origin" : "*",
  };
  if (req.method === "OPTIONS") return new Response("ok", { headers });

  try {
    const { phone } = await req.json();
    if (!phone) return new Response(JSON.stringify({ error: "phone required" }), { status: 400, headers });

    // 1. ask GetOTP to create the code
    const smsResp = await fetch("https://api.otp.dev/v1/verifications", {
      method : "POST",
      headers: {
        "X-OTP-Key" : env.GETOTP_KEY,
        "accept"    : "application/json",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        data: {
          channel : "sms",
          sender  : env.GETOTP_SENDER,
          phone   : phone.replace(/\D/g, ""),
          template: env.GETOTP_TMPL,
          code_length: 6,
        },
      }),
    });
    if (!smsResp.ok) throw `GetOTP send failed: ${await smsResp.text()}`;

    // 2. GetOTP returns the code it just generated
    const { code } = await smsResp.json();   // <- use THIS code
    console.log(`GetOTP created code for ${phone}: ${code}`);
/* ================================= */

    await saveCode(phone, code);
    await saveCode(phone, code);

    return new Response(JSON.stringify({ success: true, debug_otp: code }), { status: 200, headers });
  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify({ error: String(e) }), { status: 500, headers });
  }
});