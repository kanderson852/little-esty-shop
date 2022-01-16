class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :percent, presence: true
  validates :threshhold, presence: true
end
