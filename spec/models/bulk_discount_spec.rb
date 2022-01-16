require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'validations' do
    it { should validate_presence_of :percent}
    it { should validate_presence_of :threshhold}
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
end
