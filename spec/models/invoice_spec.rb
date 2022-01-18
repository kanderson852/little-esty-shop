require 'rails_helper'

RSpec.describe Invoice do
  before do
    @merchant_a = Merchant.create!(name: "Kelly")
    @bulk_a = @merchant_a.bulk_discounts.create!(percent: 10, threshhold: 10)
    @bulk_b = @merchant_a.bulk_discounts.create!(percent: 15, threshhold: 20)
    @item_a = @merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 10)
    @item_b = @merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 10)
    @customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    @invoice_a = @customer_a.invoices.create!
    @ii1 = @invoice_a.invoice_items.create!(item_id: @item_a.id, quantity: 12, unit_price: 10, status: 0)
    @ii2 = @invoice_a.invoice_items.create!(item_id: @item_b.id, quantity: 5, unit_price: 10, status: 0)
  end
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchant).through(:items) }
  end

  it '#total_revenue' do
    expect(@invoice_1.total_revenue).to eq(16)
    expect(@invoice_4.total_revenue).to eq(124800)
  end

  it '#discounted_revenue' do
    expect(@invoice_a.discounted_revenue).to eq(12.0)
  end

  describe 'models' do
    it '#incomplete_invoices' do
      expected_result = [@invoice_1, @invoice_2, @invoice_3,
                         @invoice_4, @invoice_5, @invoice_6,
                         @invoice_7, @invoice_8, @invoice_9,
                         @invoice_10, @invoice_11, @invoice_12,
                         @invoice_13, @invoice_14, @invoice_15,
                         @invoice_19, @invoice_20]

      #Expected result ordered oldest to newest

      expect(Invoice.incomplete_invoices).to eq(expected_result)
    end
  end
end
