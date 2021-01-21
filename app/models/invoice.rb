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
    find_discounts.each do |discount|
      item = invoice_items.find_by(item_id: discount[:item_id])
      new_price = (item.unit_price * (100 - discount.percentage_discount)/ 100)
      item.update(unit_price: new_price)
    end
  end

  def find_discounts
    self.items.joins(:bulk_discounts)
    .select('bulk_discounts.*, items.id as item_id')
    .where('quantity >= bulk_discounts.quantity_threshold')
    .order(percentage_discount: :desc)
  end
end
