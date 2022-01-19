require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_many(:transactions).through(:invoice) }
    it { should have_many(:bulk_discounts).through(:item) }
  end

  it '#selected_discount' do
    merchant_a = Merchant.create!(name: "Kelly")
    merchant_b = Merchant.create!(name: "Kara")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    bulk_b = merchant_a.bulk_discounts.create!(percent: 30, threshhold: 15)
    item_a1 = merchant_a.items.create!(name: "Item_a1", description: "Description_a", unit_price: 1600)
    item_a2 = merchant_a.items.create!(name: "Item_a2", description: "Description_b", unit_price: 2300)
    item_b = merchant_b.items.create!(name: "Item_b", description: "Description_b", unit_price: 3400)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    ii_a = invoice_a.invoice_items.create!(item_id: item_a1.id, quantity: 12, unit_price: item_a1.unit_price, status: 0)
    ii_b = invoice_a.invoice_items.create!(item_id: item_a2.id, quantity: 15, unit_price: item_a2.unit_price, status: 0)
    ii_c = invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
    expect(ii_a.selected_discount).to eq(bulk_a)
    expect(ii_b.selected_discount).to eq(bulk_b)
    expect(ii_c.selected_discount).to eq(nil)
  end
end
