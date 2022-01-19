class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :item
  validates :quantity, :unit_price, :status, presence: true
  enum status: { pending: 0, packaged: 1, shipped: 2 }

  def selected_discount
    self.bulk_discounts.where("threshhold <= ?", quantity)
    .max_by(&:percent)
  end
end
