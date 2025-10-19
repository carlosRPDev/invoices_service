module Services
  class AuditService
    def initialize
      client = Mongo::Client.new(ENV.fetch("MONGO_URL", "mongodb://mongo:27017/audit_db"))
      @collection = client[:audit_logs]
    end

    def log(message)
      @collection.insert_one({ event: message, created_at: Time.now })
    end
  end
end
