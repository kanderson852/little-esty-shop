class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(percent: params[:percent], threshhold: params[:threshhold])
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.find(params[:id])
    discount.update(params)
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{discount.id}"
  end
end
