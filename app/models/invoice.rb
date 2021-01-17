class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    apply_discount
    invoice_items.sum("unit_price * quantity")
  end

  def apply_discount
     whiskey = best_discount
     whiskey.each do |item, discount|
      item.unit_price = (item.unit_price * (100 - discount.percentage_discount)/ 100)
      item.update(unit_price: item.unit_price)
     end
  end

  def best_discount
    item_discounts_hash = find_discounts
    item_discounts_hash.each do |item, discounts|
      item_discounts_hash[item] = discounts.max_by{|discount| discount.percentage_discount}
    end
    item_discounts_hash
  end
  
  def find_discounts
    items_from_invoice = get_invoice_items
    discounts = get_discounts
    collector = Hash.new{|h, k| h[k] = [] }
    items_from_invoice.each do |item|
      discounts.each do |discount|
        collector[item] << discount if item.item_id == discount.item_id && item.quantity >= discount.quantity_threshold    
      end
    end
    collector
  end

  def get_invoice_items
    self.invoice_items
  end

  def get_discounts
    discounts = self.items.flat_map do |item|
      item.bulk_discounts
    end
  end
end
