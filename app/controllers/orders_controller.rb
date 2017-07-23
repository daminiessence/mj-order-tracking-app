class OrdersController < ApplicationController

  before_action :logged_in_user
  before_action :agent_user
  before_action :admin_user, only: [ :destroy ]
  add_breadcrumb "orders", :orders_path

  def index
    @orders = Order.where(agent_id: current_user.agent_id) || []
  end

  def show
    @order = Order.find_by(no: params[:id])
    @user = User.find_by(agent_id: @order.agent_id)
    @sales = []
    Sale.where(order_no: @order.no).each do |sale|
      product = Product.find_by(sid: sale.product_sid)
      @sales << [ sale, product ]
    end
    add_breadcrumb @order.no.to_s, order_path(@order)
  end

  def new
    @order = Order.new
    @products = []
    Product.all.each do |product|
      @products << [ "#{product.name} (ID: #{product.sid}, RM #{product.suggested_price})",
        product.sid ]
    end
    add_breadcrumb "new", new_order_path
  end

  def create
    if order_params[:sales_attributes]
      order = current_user.orders.create(no: order_params[:no])
      order_params[:sales_attributes].each do |key, value|
        product = Product.find_by(sid: value[:product_sid])
        sale_price = (value[:sale_price].is_a? Numeric) ? value[:sale_price] :
          product.suggested_price
        sale = Sale.create(order_no: order.no, product_sid: value[:product_sid], sale_price:
          sale_price, amount: value[:amount].to_i)
      end
    else
      order = current_user.orders.build(order_params)
    end
    if order.save
      flash[:success] = "TODO: ok"
      redirect_to orders_url
    else
      flash.now[:danger] = "TODO: error!"
      render :new
    end
  end

  def edit
    @order = Order.find_by(id: params[:id])
    @sales = @order.sales.all
  end

  def update
  end

  def destroy
  end

  private

    def order_params
      params.require(:order).permit(:no, sales_attributes: [ :product_sid, :sale_price, :amount ])
    end
end
