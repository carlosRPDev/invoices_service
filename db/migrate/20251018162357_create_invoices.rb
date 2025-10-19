class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.integer :client_id
      t.decimal :total
      t.datetime :issued_at

      t.timestamps
    end
  end
end
