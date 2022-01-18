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

  it 'I see the total discounted revenue for my merchant from this invoice' do
    visit merchant_invoice_path(@merchant_1, @invoice_4)
    expect(page).to have_content("Total Revenue with discounts")
    expect(page).to have_content("$998")
  end

  it 'In this example, no bulk discounts should be applied.' do
    merchant_a = Merchant.create!(name: "Kelly")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    item_a = merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 1600)
    item_b = merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 2300)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    ii_a = invoice_a.invoice_items.create!(item_id: item_a.id, quantity: 5, unit_price: item_a.unit_price, status: 0)
    ii_b = invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 5, unit_price: item_b.unit_price, status: 0)
    visit merchant_invoice_path(merchant_a, invoice_a)
    expect(page).to have_content("Total Revenue before discounts: $195")
    expect(page).to have_content("Total Revenue with discounts: $195")
  end

  it 'In this example, Item a should be discounted at 20% off. Item b should not be discounted.' do
    merchant_a = Merchant.create!(name: "Kelly")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    item_a = merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 1600)
    item_b = merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 2300)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    invoice_a.invoice_items.create!(item_id: item_a.id, quantity: 10, unit_price: 1600, status: 2)
    invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 5, unit_price: 2300, status: 2)
    visit merchant_invoice_path(merchant_a, invoice_a)
    expect(page).to have_content("Total Revenue before discounts: $275")
    expect(page).to have_content("Total Revenue with discounts: $243")
  end

  it 'In this example, Item A should discounted at 20% off, and Item B should discounted at 30% off.' do
    merchant_a = Merchant.create!(name: "Kelly")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    bulk_b = merchant_a.bulk_discounts.create!(percent: 30, threshhold: 15)
    item_a = merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 1600)
    item_b = merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 2300)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    invoice_a.invoice_items.create!(item_id: item_a.id, quantity: 12, unit_price: item_a.unit_price, status: 0)
    invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
    visit merchant_invoice_path(merchant_a, invoice_a)
    expect(page).to have_content("Total Revenue before discounts: $537")
    expect(page).to have_content("Total Revenue with discounts: $395")
  end

  it 'In this example, Both Item A and Item B should discounted at 20% off.' do
    merchant_a = Merchant.create!(name: "Kelly")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    bulk_b = merchant_a.bulk_discounts.create!(percent: 15, threshhold: 15)
    item_a = merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 1600)
    item_b = merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 2300)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    invoice_a.invoice_items.create!(item_id: item_a.id, quantity: 12, unit_price: item_a.unit_price, status: 0)
    invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
    visit merchant_invoice_path(merchant_a, invoice_a)
    expect(page).to have_content("Total Revenue before discounts: $537")
    expect(page).to have_content("Total Revenue with discounts: $430")
  end

  it 'In this example, Item A1 should discounted at 20% off, and Item A2 should discounted at 30% off. Item B should not be discounted.' do
    merchant_a = Merchant.create!(name: "Kelly")
    merchant_b = Merchant.create!(name: "Kara")
    bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
    bulk_b = merchant_a.bulk_discounts.create!(percent: 30, threshhold: 15)
    item_a1 = merchant_a.items.create!(name: "Item_a1", description: "Description_a", unit_price: 1600)
    item_a2 = merchant_a.items.create!(name: "Item_a2", description: "Description_b", unit_price: 2300)
    item_b = merchant_b.items.create!(name: "Item_b", description: "Description_b", unit_price: 3400)
    customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
    invoice_a = customer_a.invoices.create!
    invoice_a.invoice_items.create!(item_id: item_a1.id, quantity: 12, unit_price: item_a1.unit_price, status: 0)
    invoice_a.invoice_items.create!(item_id: item_a2.id, quantity: 15, unit_price: item_a2.unit_price, status: 0)
    invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
    visit merchant_invoice_path(merchant_a, invoice_a)
    expect(page).to have_content("Total Revenue before discounts: $1,047")
    expect(page).to have_content("Total Revenue with discounts: $905")
  end

  it 'Next to each invoice item I see a link to the show page for the bulk discount' do
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
    invoice_a.invoice_items.create!(item_id: item_a2.id, quantity: 15, unit_price: item_a2.unit_price, status: 0)
    invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
    visit merchant_invoice_path(merchant_a, invoice_a)
    within "#item-#{ii_a.id}" do
      # save_and_open_page
      click_link("#{ii_a.item.name}")
      expect(current_path).to eq("/merchants/#{merchant_a.id}/bulk_discounts/#{bulk_a.id}")
    end
  end
end
