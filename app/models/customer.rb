class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  validates :first_name, presence: true
  validates :last_name, presence: true

  def successful_transactions_count
    transactions.where(result: "success").count
  end

  def self.top_customers
    joins(:transactions)
    .where(transactions: {result: "success"})
    .group(:id)
    .select("customers.*, count(transactions) as num_transactions")
    .order(num_transactions: :desc)
    .limit(5)
  end
end
