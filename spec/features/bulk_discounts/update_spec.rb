require 'rails_helper'

RSpec.describe 'Bulk discounts Edit' do
  describe 'view' do
    before do
      @bulk1 = @merchant_1.bulk_discounts.create!(percent: 20, threshhold: 10)
      @bulk2 = @merchant_1.bulk_discounts.create!(percent: 15, threshhold: 5)
      @bulk3 = @merchant_1.bulk_discounts.create!(percent: 10, threshhold: 15)
      @bulk4 = @merchant_1.bulk_discounts.create!(percent: 5, threshhold: 3)
      visit "/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}/edit"
    end

    it 'updates the discount' do
      expect(page).to have_field(:percent, with: @bulk1.percent)
      fill_in(:percent, with: 17)
      fill_in(:threshhold, with: 7)
      click_button "Update Discount"
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}")
      expect(page).to have_content("Percentage discount: 17")
      expect(page).to have_content("Quantity threshold: 7")
    end
  end
end
