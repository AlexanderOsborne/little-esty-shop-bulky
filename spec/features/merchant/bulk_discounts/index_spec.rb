require 'rails_helper'

RSpec.describe 'Bulk Index', type: :feature do
  describe 'As a merchant' do
    before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(merchant_id: @merchant1.id, customer_id: @customer_6.id, status: 1)

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
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
    
    @bulk_discount1 = BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 15, merchant_id: @merchant1.id, item_id: @item_1.id)
    @bulk_discount2 = BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 30, merchant_id: @merchant1.id, item_id: @item_4.id)
    end

    it 'I see a link to create a new discount, when I click this link I am takent to a new page where I see a form to add a new discount, when I fill this in with valid data then I am redirected back to the index and see the new discount' do
    visit merchant_dashboard_index_path(@merchant1)

    click_link "Discounts"
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1.id))
    
    click_link "Create Discount"
    fill_in "percentage_discount", with: '50'
    fill_in "quantity_threshold", with: '50'
    select("#{@item_1.name}", from: "item_id")
    click_button "Save"
    
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1.id))
    expect(page).to have_content(50)
    end

    it 'I see a link to delete a discount, when I click this link I am redirected back to the index' do
      visit merchant_bulk_discounts_path(@merchant1.id)  
      click_link("Delete", match: :first)
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1.id))
      expect(page).to have_no_content(@bulk_discount1.percentage_discount)
      expect(page).to have_content(@bulk_discount2.percentage_discount)
    end
  end
end