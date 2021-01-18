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

  def edit
    find_merchant
    @discount = BulkDiscount.find(params[:id])
  end

  def destroy
    @discount=BulkDiscount.find(params[:id])
    @discount.destroy
    flash.notice="Discount was deleted"
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def create
    if params["item_id"] == ""
      bulk_discount_params1 = bulk_discount_params
      items = Item.all
        items.each do |item|
          bulk_discount_params1["item_id"] = item.id
          BulkDiscount.create!(bulk_discount_params1)
       end
       redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
    BulkDiscount.create!(bulk_discount_params)
    flash.notice = 'Discount Has Been Created!'
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    end
  end

  def update
    bulk_discount_params1 = bulk_discount_params
    @discount = BulkDiscount.find(params[:id])
    if @discount.save
      bulk_discount_params1["item_id"] = @discount[:item_id]
      @discount.update(bulk_discount_params1)
    else
      render edit
    end
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