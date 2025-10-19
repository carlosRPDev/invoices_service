module Repositories
  class OracleInvoiceRepository
    def save(invoice)
      record = ::Invoice.create!(
        client_id: invoice.client_id,
        total: invoice.total,
        issued_at: invoice.issued_at
      )
      record
    end

    def find(id)
      ::Invoice.find_by(id: id)
    end

    def between_dates(start_date, end_date)
      ::Invoice.where(issued_at: start_date..end_date)
    end
  end
end
