require 'rails_helper'

RSpec.describe 'Bulk discounts new' do
  before do
    @bulk1 = @merchant_1.bulk_discounts.create!(percent: 20, threshhold: 10)
    @bulk2 = @merchant_1.bulk_discounts.create!(percent: 15, threshhold: 5)
    @bulk3 = @merchant_1.bulk_discounts.create!(percent: 10, threshhold: 15)
    @bulk4 = @merchant_1.bulk_discounts.create!(percent: 5, threshhold: 3)
    visit "/merchants/#{@merchant_1.id}/bulk_discounts/new"
  end
  describe 'view' do
    it 'I see a form to add a new bulk discount' do
      fill_in("Percent", with: 25)
      fill_in("Threshhold", with: 11)
      click_button("Submit")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
      expect(page).to have_content("Percentage discount: 25")
    end

    xit 'I get an error if form is filled out incorrectly' do
      click_button("Submit")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/new")
      expect(page).to have_content("Error: Discount can't be blank, Threshhold can't be blank")
    end
  end
end
