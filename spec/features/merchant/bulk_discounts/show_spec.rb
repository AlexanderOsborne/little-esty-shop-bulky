require 'rails_helper'

RSpec.describe 'as a merchant', type: :feature do
  describe 'when I visit my bulk discount show page' do
    before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')

    @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_3.id, status: 2)
    

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    
    @bulk_discount1 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 15, merchant_id: @merchant1.id, item_id: @item_1.id)
    @bulk_discount2 = BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 30, merchant_id: @merchant1.id, item_id: @item_4.id)
    end

    it 'When I visit my bulk discount show page I see the bulk discounts quantity and price' do
      visit merchant_bulk_discount_path(id: @bulk_discount1.id, merchant_id: @bulk_discount1.merchant_id)

      expect(page).to have_content(@bulk_discount1.percentage_discount)
      expect(page).to have_content(@bulk_discount1.quantity_threshold)
    end

    it 'when I visit the show page I see a link to edit the discount, when i click this link I am taken to a new page to edit, after submitting I am back at the show page and see the update' do
      visit merchant_bulk_discount_path(id: @bulk_discount1.id, merchant_id: @bulk_discount1.merchant_id)
      click_link "Update Discount"
      
      expect(current_path).to eq(edit_merchant_bulk_discount_path(id: @bulk_discount1.id, merchant_id: @bulk_discount1.merchant_id))
  
      # expect(page).to have_content(@bulk_discount1.percentage_discount)
      # expect(page).to have_content(@bulk_discount1.quantity_threshold)

      fill_in "percentage_discount", with: '50'
      fill_in "quantity_threshold", with: '100'
      click_button "Save"

      expect(current_path).to eq(merchant_bulk_discount_path(id: @bulk_discount1.id, merchant_id: @bulk_discount1.merchant_id))
      expect(page).to have_content(50)
      expect(page).to have_content(100)
    end
  end
end