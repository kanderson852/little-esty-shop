class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :percent
      t.integer :threshhold
      t.references :merchant, foreign_key: true
    end
  end
end
