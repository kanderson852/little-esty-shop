require 'rails_helper'

RSpec.describe 'Bulk discounts Index' do
  describe 'view' do
    before do
      @bulk1 = @merchant_1.bulk_discounts.create!(percent: 20, threshhold: 10)
      @bulk2 = @merchant_1.bulk_discounts.create!(percent: 15, threshhold: 5)
      @bulk3 = @merchant_1.bulk_discounts.create!(percent: 10, threshhold: 15)
      @bulk4 = @merchant_1.bulk_discounts.create!(percent: 5, threshhold: 3)
      visit "/merchants/#{@merchant_1.id}/bulk_discounts"
    end

    it 'I see all of my bulk discounts' do
      within "#discount-#{@bulk1.id}" do
        expect(page).to have_content(@bulk1.percent)
        expect(page).to have_content(@bulk1.threshhold)
      end
      within "#discount-#{@bulk2.id}" do
        expect(page).to have_content(@bulk2.percent)
        expect(page).to have_content(@bulk2.threshhold)
      end
      within "#discount-#{@bulk3.id}" do
        expect(page).to have_content(@bulk3.percent)
        expect(page).to have_content(@bulk3.threshhold)
      end
      within "#discount-#{@bulk4.id}" do
        expect(page).to have_content(@bulk4.percent)
        expect(page).to have_content(@bulk4.threshhold)
      end
    end

    it 'each bulk discount listed includes a link to its show page' do
      within "#discount-#{@bulk1.id}" do
        expect(page).to have_link(@bulk1.percent)
        click_link(@bulk1.percent)
        expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/#{@bulk1.id}")
      end
    end

    it 'I see a link to create a new discount' do
      click_link("Create new discount")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts/new")
    end
  end
end
