require "httparty"

class AuditClient
  include HTTParty
  base_uri ENV.fetch("AUDIT_URL", "http://audit:3002")

  def post_event(payload)
    response = self.class.post(
      "/api/v1/audit/events",
      body: { audit_event: payload }.to_json,
      headers: { "Content-Type" => "application/json" }
    )

    if response.success?
      Rails.logger.info("[AuditClient] Evento registrado: #{payload[:action]} (#{response.code})")
    else
      Rails.logger.warn("[AuditClient] Falló envío (#{response.code}): #{response.body}")
    end

    response
  rescue => e
    Rails.logger.error("❌ [AuditClient] Error posting audit event: #{e.message}")
    nil
  end
end
