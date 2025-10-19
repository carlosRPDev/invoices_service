module Clients
  class ClientsService
    include HTTParty
    base_uri ENV.fetch("CLIENTS_URL", "http://clients:3000")

    def find(id)
      response = self.class.get("/api/v1/clients/#{id}")
      response.success? ? JSON.parse(response.body) : nil
    rescue
      nil
    end
  end
end
