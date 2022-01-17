require 'rails_helper'

RSpec.describe 'Bulk discounts Show' do
  describe 'view' do
    before do
      @bulk1 = @merchant_1.bulk_discounts.create!(percent: 20, threshhold: 10)
      @bulk2 = @merchant_1.bulk_discounts.create!(percent: 15, threshhold: 5)
      @bulk3 = @merchant_1.bulk_discounts.create!(percent: 10, threshhold: 15)
      @bulk4 = @merchant_1.bulk_discounts.create!(percent: 5, threshhold: 3)
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}"
    end

    it 'I see the bulk discounts quantity threshold and percentage discount' do
      expect(page).to have_content("Percentage discount: #{@bulk1.percent}")
      expect(page).to have_content("Quantity threshold: #{@bulk1.threshhold}")
      expect(page).to_not have_content("Percentage discount: #{@bulk2.percent}")
    end

    it 'I see a link to edit the bulk discount' do
      expect(page).to have_link("Edit #{@bulk1.percent}")
      click_link("Edit #{@bulk1.percent}")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}/edit")
    end
  end
end
