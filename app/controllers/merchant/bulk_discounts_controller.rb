class Merchant::BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
  end
  
  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    find_merchant
  end

  def destroy
    @discount=BulkDiscount.find(params[:id])
    @discount.destroy
    flash.notice="Discount was deleted"
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def create
    BulkDiscount.create!(bulk_discount_params)
    flash.notice = 'Discount Has Been Created!'
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def update
    @discount = BulkDiscount.find(params[:id])
    @discount.update(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(id: @discount.id, merchant_id: @discount.merchant_id)
  end

  private
  def bulk_discount_params
    params.permit(:percentage_discount, :quantity_threshold, :merchant_id, :item_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_item
    @item = Item.find(params[:item_id])
  end
end