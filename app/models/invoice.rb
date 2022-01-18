class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchant, through: :items
  validates :status, presence: true
  enum status: { cancelled: 0, "in progress" => 1, completed: 2, pending: 3 }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.threshhold')
    .select('invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent / 100.0)) as item_discount')
    .group('invoice_items.id')
    .order(item_discount: :desc)
    .sum(&:item_discount)
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: "shipped"})
    .order(created_at: :asc)
    .distinct
  end
end
