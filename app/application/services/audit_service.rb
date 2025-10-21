module Services
  class AuditService
    def log(message, action: "CREATE_INVOICE", state: "OK", detail: {})
      RegisterEventAuditJob.perform_later(
        origin_service: "invoices",
        action: "CREATE_INVOICE",
        detail: { message: message }.merge(detail),
        state: "OK"
      )
    rescue => e
      Rails.logger.error("[AuditService] Error al encolar evento: #{e.message}")
    end
  end
end
