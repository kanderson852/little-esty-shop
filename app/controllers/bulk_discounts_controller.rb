class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discounts = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(percent: params[:percent], threshhold: params[:threshhold])
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end
end
