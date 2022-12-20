class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :quantity, default: 1, null: false
      t.integer :discount_percentage, default: 0, null: false
      t.integer :price_cents, null: false
      t.integer :total_cents, null: false

      t.timestamps
    end
  end
end
