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
  const missing = Object.entries(env).filter(([, v]) => !v).map(([k]) => k);
  if (missing.length) throw `Missing env: ${missing.join(", ")}`;
})();

/* ---------- helpers ---------- */
const sb = createClient(env.SB_URL, env.SB_SERVICE_KEY);
const hash = (s: string) => btoa(s);
const fiveMin = () => new Date(Date.now() + 5 * 60 * 1000).toISOString();

/* ---------- db ---------- */
async function saveCode(phone: string, code: string) {
  await sb.from("otp_verifications").delete().eq("phone", phone);

  const { error } = await sb.from("otp_verifications").insert({
    phone,
    otp_hash: hash(code),
    expires_at: fiveMin(),
    verified: false,
  });

  if (error) throw `DB error: ${error.message}`;
}

/* ---------- handler ---------- */
serve(async (req) => {
  const headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
  };

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers });
  }

  try {
    const { phone } = await req.json();
    if (!phone) {
      return new Response(
        JSON.stringify({ error: "phone required" }),
        { status: 400, headers }
      );
    }

    // ✅ DECLARE CODE BEFORE USING IT
    const code = "123456"; // DEV MODE (no SMS balance needed)

    // 🔕 Skip GetOTP call while balance is 0
    // (When balance is back, send SMS here)

    await saveCode(phone, code);

    return new Response(
      JSON.stringify({
        success: true,
        debug_otp: code, // 👈 visible for testing
      }),
      { status: 200, headers }
    );

  } catch (e) {
    console.error(e);
    return new Response(
      JSON.stringify({ error: String(e) }),
      { status: 500, headers }
    );
  }
});