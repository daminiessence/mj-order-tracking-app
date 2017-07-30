require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @agent = users(:admin)
    log_in(@agent)
    @non_agent = users(:unverified_agent)
  end

  test "should get index" do
    get orders_path
    assert_response :success
  end

  test "agent can visit new" do
    get new_order_path
    assert_not flash.empty?
    assert_template 'orders/new'
  end

  test "should redirect when non agent visits new" do
    log_in(@non_agent)
    get new_order_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "agent can post new order" do
    order = @agent.orders.build(no: 99)
    assert order.valid?
    assert_difference 'Order.count', 1 do
      post orders_path, params: { order: { no: order.no } }
    end
  end

  test "should redirect create for non agent" do
    log_in(@non_agent)
    order = @non_agent.orders.build(no: 99)
    assert order.valid?
    assert_no_difference 'Order.count' do
      post orders_path, params: { order: { no: order.no } }
    end
    assert_redirected_to root_url
  end

  test "adding a new sale to non existing order should fail" do
    non_existing_order_no = 99
    assert_not Order.exists?(no: non_existing_order_no)
    assert_no_difference 'Sale.count' do
      sale = Sale.new(order_no: non_existing_order_no, product_sid: Product.first.sid,
        sale_price: 99.99, amount: 1)
      sale.save
    end
  end

  test "non admin could not destroy" do
  end
end
