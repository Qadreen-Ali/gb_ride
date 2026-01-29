// supabase/functions/verify-otp/index.ts
import { serve } from "std/http/server.ts";
import { createClient } from "supabase-js";

/* ---------- env ---------- */
const SB_URL  = Deno.env.get("SUPABASE_URL")!;
const SB_SERV = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
if (!SB_URL || !SB_SERV) throw "Missing Supabase env";

const sb = createClient(SB_URL, SB_SERV);
const hash = (s: string) => btoa(s);

const cors = {
  "Content-Type"                 : "application/json",
  "Access-Control-Allow-Origin"  : "*",
  "Access-Control-Allow-Headers" : "authorization, x-client-info, apikey, content-type",
};

/* ---------- handler ---------- */
serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  try {
    const { phone, otp } = await req.json();
    if (!phone || !otp) return new Response(JSON.stringify({ error: "phone and otp required" }), { status: 400, headers: cors });

    const { data, error } = await sb
      .from("otp_verifications")
      .select("id")
      .eq("phone", phone)
      .eq("otp_hash", hash(otp))
      .eq("verified", false)
      .gt("expires_at", new Date().toISOString())
      .single();

    if (error || !data) return new Response(JSON.stringify({ success: false, error: "Invalid or expired OTP" }), { status: 400, headers: cors });

    await sb.from("otp_verifications").update({ verified: true }).eq("id", data.id);

    return new Response(JSON.stringify({ success: true }), { status: 200, headers: cors });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), { status: 500, headers: cors });
  }
});