require 'rails_helper'

RSpec.describe Entities::Invoice, type: :model do
  describe '#valid?' do
    it 'es válido con client_id, total y issued_at correctos' do
      invoice = described_class.new(
        client_id: 1,
        total: 100.5,
        issued_at: Time.current
      )
      expect(invoice.valid?).to be true
    end

    it 'no es válido si falta client_id' do
      invoice = described_class.new(
        client_id: nil,
        total: 100,
        issued_at: Time.current
      )
      expect(invoice.valid?).to be false
    end

    it 'no es válido si el total es cero o negativo' do
      invoice = described_class.new(
        client_id: 1,
        total: 0,
        issued_at: Time.current
      )
      expect(invoice.valid?).to be false
    end

    it 'no es válido si issued_at no es una instancia de Time' do
      invoice = described_class.new(
        client_id: 1,
        total: 100,
        issued_at: '2025-10-18'
      )
      expect(invoice.valid?).to be false
    end
  end
end
