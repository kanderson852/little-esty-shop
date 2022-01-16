class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discounts = BulkDiscount.find(params[:id])
  end
end
