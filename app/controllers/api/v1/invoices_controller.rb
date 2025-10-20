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
        render json: { id: invoice.id, message: "Factura creada correctamente" }, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def show
        repo = Repositories::OracleInvoiceRepository.new
        invoice = repo.find(params[:id])
        if invoice
          render json: invoice
        else
          render json: { error: "Factura no encontrada" }, status: :not_found
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
