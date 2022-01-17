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
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: "shipped"})
    .order(created_at: :asc)
    .distinct
  end
end
