module Entities
  class Invoice
    attr_accessor :client_id, :total, :issued_at

    def initialize(client_id:, total:, issued_at:)
      @client_id = client_id
      @total = total
      @issued_at = parse_time(issued_at)
    end

    def valid?
      client_id.present? && total.to_f > 0 && issued_at.is_a?(Time)
    end

    private

    def parse_time(value)
      return value if value.is_a?(Time)
      Time.parse(value.to_s) rescue nil
    end
  end
end
