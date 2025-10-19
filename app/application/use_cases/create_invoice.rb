module UseCases
  class CreateInvoice
    def initialize(client_repo:, invoice_repo:, audit_service:)
      @client_repo = client_repo
      @invoice_repo = invoice_repo
      @audit_service = audit_service
    end

    def call(params)
      event_message = nil

      begin
        client = @client_repo.find(params[:client_id])
        raise "Client no encontrado" unless client

        invoice = Entities::Invoice.new(
          client_id: params[:client_id],
          total: params[:total],
          issued_at: params[:issued_at]
        )

        raise "Datos de factura inválidos" unless invoice.valid?

        record = @invoice_repo.save(invoice)
        event_message = "Factura creada: #{record.id} para cliente #{invoice.client_id}"
        record
      rescue StandardError => e
        event_message = "Error al crear factura: #{e.message} (params: #{params})"
        raise e
      ensure
        @audit_service.log(event_message) if event_message
      end
    end
  end
end
