class CreateBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.references :product
      t.string :barcode
      t.integer :quantity 
      t.date :expiration_date
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps
    end

    add_index :batches, :barcode
    add_foreign_key :batches, :products, on_delete: :cascade
  end
end
