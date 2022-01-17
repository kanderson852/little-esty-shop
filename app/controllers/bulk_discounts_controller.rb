class BulkDiscountsController < ApplicationController


  def index
    @merchant = merchant_finder
  end

  def show
    @merchant = merchant_finder
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = merchant_finder
  end

  def create
    @merchant = merchant_finder
    @merchant.bulk_discounts.create!(discount_params)
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def destroy
    @merchant = merchant_finder
    discount = @merchant.bulk_discounts.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
  end

  def edit
    @merchant = merchant_finder
    @discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = merchant_finder
    @discount = @merchant.bulk_discounts.find(params[:id])
    @discount.update(discount_params)
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}"
  end

private
  def merchant_finder
    Merchant.find(params[:merchant_id])
  end

  def discount_params
    params.permit(:id, :percent, :threshhold, :merchant_id)
  end
end
