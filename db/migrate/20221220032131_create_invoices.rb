class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices, id: :string do |t|
      t.integer :invoice_number, null: false, unique: true
      t.date :invoice_date, null: false
      t.date :due_date, null: false
      t.string :customer_name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.integer :total_cents, null: false
      t.integer :balance_cents, null: false

      t.timestamps
    end
  end
end
