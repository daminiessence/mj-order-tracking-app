require 'test_helper'

class SaleTest < ActiveSupport::TestCase

  def setup
    @user = users(:faithess)
    @product = products(:soap)
    @order = @user.orders.build(no: 999)
    @order.save
    @invalid_order_no = 9876
    @invalid_product_sid = "INVALID"
  end

  def teardown
  end

  test "preconditions" do
    assert User.exists?(@user.id)
    assert Order.exists?(@order.id)
    assert Product.exists?(@product.id)
    assert_not Order.find_by(no: @invalid_order_no)
    assert_not Product.find_by(sid: @invalid_product_sid)
  end

  test "saving using valid sale_price and amount" do
    sales = [
      {
        sale_price: 10.00,
        amount: 001
      },
      {
        sale_price: 0.01,
        amount: 10
      },
      {
        sale_price: 0.00,
        amount: 99
      }
    ]
    sales.each do |sale_info|
      sale = @order.sales.build(product_sid: @product.sid,
        sale_price: sale_info[:sale_price], amount: sale_info[:amount])
      assert sale.valid?, "sale_price: #{sale_info[:sale_price]}, amount: #{sale_info[:amount]}"\
        " should be valid"
    end
  end

  test "saving using invalid sale_price" do
    invalid_sale_prices = [
      -10.00
    ]
    invalid_sale_prices.each do |invalid_price|
      sale = @order.sales.build(product_sid: @product.sid, sale_price: invalid_price, amount: 1)
      assert_not sale.valid?, "sale_price: #{invalid_price} should not be valid."
    end
  end

  test "saving using invalid amount" do
    invalid_amounts = [
      0,
      -10,
      1.9,
      0.9
    ]
    invalid_amounts.each do |invalid_amount|
      sale = @order.sales.build(product_sid: @product.sid, sale_price: 99.99,
        amount: invalid_amount)
      assert_not sale.valid?, "amount: #{invalid_amount} should not be valid."
    end
  end

  test "saving using invalid order_no" do
    sale = @order.sales.build(product_sid: @product.sid,
      sale_price: 99.99, amount: 1)
    assert sale.valid?
    sale.order_no = @invalid_order_no
    assert_no_difference 'Sale.count' do
      sale.save
    end
  end

  test "saving using invalid product_sid" do
    sale = @order.sales.build(product_sid: @product.sid,
      sale_price: 99.99, amount: 1)
    assert sale.valid?
    sale.product_sid = @invalid_product_sid
    assert_no_difference 'Sale.count' do
      sale.save
    end
  end
end
