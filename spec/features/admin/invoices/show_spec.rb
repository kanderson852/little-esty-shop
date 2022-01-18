require 'rails_helper'

RSpec.describe 'Admin Invoices Show' do
  describe 'view' do

    it 'I see information related to that invoice' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
      expect(page).to have_content(@invoice_1.customer.first_name)
      expect(page).to have_content(@invoice_1.customer.last_name)
    end

    it 'I see the total discounted revenue for my merchant from this invoice with and without discounts' do
      merchant_a = Merchant.create!(name: "Kelly")
      bulk_a = merchant_a.bulk_discounts.create!(percent: 20, threshhold: 10)
      item_a = merchant_a.items.create!(name: "Item_a", description: "Description_a", unit_price: 1600)
      item_b = merchant_a.items.create!(name: "Item_b", description: "Description_b", unit_price: 2300)
      customer_a = Customer.create!(first_name: "Customera", last_name: "1a")
      invoice_a = customer_a.invoices.create!
      ii_a = invoice_a.invoice_items.create!(item_id: item_a.id, quantity: 10, unit_price: item_a.unit_price, status: 0)
      ii_b = invoice_a.invoice_items.create!(item_id: item_b.id, quantity: 15, unit_price: item_b.unit_price, status: 0)
      visit "/admin/invoices/#{invoice_a.id}"
      expect(page).to have_content("Total revenue before discounts: $505")
      expect(page).to have_content("Total Revenue with discounts: $404")
    end

    it 'I can update the invoice status' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("pending")
      select "in progress", from: "invoice_status"
      click_on "Update Invoice Status"

      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content("#{@invoice_1.status}")
    end

    it 'displays all of the items and their attributes' do
      visit "/admin/invoices/#{@invoice_1.id}"

      within "#invoice_show-#{@invoice_1.id}" do
        expect(page).to have_content("#{@invoice_1.invoice_items.first.item.name}")
        expect(page).to have_content("#{@invoice_1.invoice_items.first.quantity}")
        expect(page).to have_content("#{@invoice_1.invoice_items.first.unit_price}")
        expect(page).to have_content("#{@invoice_1.invoice_items.first.status}")
      end
    end
  end
end
