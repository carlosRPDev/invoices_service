module Services
  class AuditService
    def log(message, action: "CREATE_INVOICE", state: "OK", detail: {})
      RegisterEventAuditJob.perform_later(
        origin_service: "invoices",
        action: action,
        detail: { message: message }.merge(detail),
        state: state
      )
    end
  end
end
