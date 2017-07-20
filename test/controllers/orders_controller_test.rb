require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @faithy = users(:faithess)
    @non_agent = users(:non_agent)
  end

  test "should get index" do
    get orders_path
    assert_response :success
  end

  test "agent can visit new" do
    log_in(@faithy)
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
    log_in(@faithy)
    order = @faithy.orders.build(no: 99)
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
end
