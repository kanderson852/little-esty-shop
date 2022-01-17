require 'rails_helper'

RSpec.describe "Merchant invoice show" do
  before do
    @bulk1 = @merchant_1.bulk_discounts.create!(percent: 20, threshhold: 10)
    @bulk2 = @merchant_1.bulk_discounts.create!(percent: 15, threshhold: 5)
    @bulk3 = @merchant_1.bulk_discounts.create!(percent: 10, threshhold: 15)
    @bulk4 = @merchant_1.bulk_discounts.create!(percent: 5, threshhold: 3)
  end
  it 'shows all the information relation to the invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status)
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y") )
    expect(page).to have_content(@invoice_1.customer.first_name)
    expect(page).to have_content(@invoice_1.customer.last_name)
  end

  it 'shows all items and information' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    @invoice_1.invoice_items.each do |invoice_item|
      expect(page).to have_content(invoice_item.item.name)
      expect(page).to have_content(invoice_item.quantity)
      expect(page).to have_content("Price: #{h.number_to_currency(invoice_item.unit_price/100, precision: 0)}")
      expect(page).to have_content(invoice_item.status)
    end
  end

  it 'does not show other merchants items info' do
    other_merchant = Merchant.create!(name: "Other Merchant")
    other_merchant_item = other_merchant.items.create!(name: "Other Merchant Item", description: "Description of other merchants item", unit_price: 33)

    visit merchant_invoice_path(@merchant_1, @invoice_1)

    expect(page).to_not have_content("#{other_merchant_item.name}")
  end

  it 'has a select field to update the invoice_item status' do
    visit merchant_invoice_path(@merchant_1, @invoice_1)

    @invoice_1.invoice_items.each do |invoice_item|
      expect(page).to have_content("pending")
      select "packaged", from: "invoice_item_status"
      click_on "Update Item Status"

      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))
      expect(page).to have_content("#{invoice_item.status}")
    end
  end

  it 'I see the total revenue that will be generated from all of my items on the invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)
    expect(page).to have_content("Total Revenue before discounts")
    expect(page).to have_content(h.number_to_currency(@invoice_4.total_revenue/100, precision: 0))
  end

  xit 'I see the total discounted revenue for my merchant from this invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)
    expect(page).to have_content("Total Revenue with discounts")
    expect(page).to have_content('')
  end

  xit 'Next to each invoice item I see a link to the show page for the bulk discount' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)
    within "#item-#{@item_4.id}" do
      click_link("Discounts applied: #{@bulk1.percent}")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}")
    end
  end
end
