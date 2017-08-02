class OrdersController < ApplicationController

  before_action :logged_in_user
  before_action :agent_user, except: :destroy
  before_action :admin_user, only: [ :destroy ]

  add_breadcrumb "orders", :orders_path

  def index
    @orders = Order.where(agent_id: current_user.agent_id) || []
  end

  def show
    @order = Order.find_by(id: params[:id])
    @user = User.find_by(agent_id: @order.agent_id)
    @sales = []
    Sale.where(order_no: @order.no).each do |sale|
      product = Product.find_by(sid: sale.product_sid)
      @sales << [ sale, product ]
    end
    add_breadcrumb @order.no.to_s, order_path(@order)
  end

  def new
    @order ||= Order.new
    @products = product_selection
    add_breadcrumb "new", new_order_path
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to orders_url
    else
      @products = product_selection
      add_breadcrumb "new"
      render :new
    end
  end

  def destroy
    Order.find(params[:id]).destroy
    flash[:success] = "TODO: the order is destroyed"
    redirect_to orders_url
  end

  private

    def order_params
      params.require(:order).permit(:no, sales_attributes: [ :product_sid, :sale_price, :amount ])
    end

    def product_selection
      p_selection = []
      Product.all.each do |product|
        p_selection << [
          "#{product.name} (ID: #{product.sid}, #{product.formatted_suggested_price})",
          product.sid
        ]
      end
      p_selection
    end
end
