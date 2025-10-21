module Api
  module V1
    class InvoicesController < ApplicationController
      def create
        use_case = UseCases::CreateInvoice.new(
          client_repo: Clients::ClientsService.new,
          invoice_repo: Repositories::OracleInvoiceRepository.new,
          audit_service: Services::AuditService.new
        )

        invoice = use_case.call(invoice_params)
        render_success(data: { id: invoice.id, message: "Factura creada correctamente" }, status: :created)
      rescue ActiveRecord::RecordInvalid => e
        render_error(message: "Datos inválidos: #{e.message}")
      rescue => e
        Rails.logger.error("[Invoices] Error al crear factura: #{e.message}")
        render_error(message: "Error al crear factura", status: :internal_server_error)
      end

      def show
        repo = Repositories::OracleInvoiceRepository.new
        invoice = repo.find(params[:id])
        if invoice
          render json: invoice
        else
          render_not_found("Factura")
        end
      end

      def index
        repo = Repositories::OracleInvoiceRepository.new
        facturas = repo.between_dates(params[:fechaInicio], params[:fechaFin])
        render json: facturas
      end

      private

      def invoice_params
        params.require(:invoice).permit(:client_id, :total, :issued_at)
      end
    end
  end
end
