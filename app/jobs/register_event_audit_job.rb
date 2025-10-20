class RegisterEventAuditJob < ApplicationJob
  queue_as :register_event_audit_invoices

  def perform(origin_service:, action:, detail:, state: "OK")
    payload = {
      timestamp: Time.current.utc.iso8601,
      origin_service: origin_service,
      action: action,
      detail: detail,
      state: state
    }

    AuditClient.new.post_event(payload)
  rescue => e
    Rails.logger.error("❌ [Audit] Falló el envío del evento de auditoría: #{e.message}")
  end
end
