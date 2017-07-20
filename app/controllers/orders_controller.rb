class OrdersController < ApplicationController

  before_action :logged_in_user
  before_action :agent_user
  before_action :admin_user, only: [ :destroy ]

  def index
    @orders = Order.all || []
  end

  def show
    @order = Order.find_by(no: params[:id])
    @user = User.find_by(id: @order.user_id)
    @sales = []
    Sale.where(order_no: @order.no).each do |sale|
      product = Product.find_by(sid: sale.product_sid)
      @sales << [ sale, product ]
    end
  end

  def new
    @order = Order.new
    @products = []
    Product.all.each do |product|
      @products << [ "#{product.name} (ID: #{product.sid})", product.sid ]
    end
  end

  def create
    if order_params[:sales_attributes]
      order = current_user.orders.create(no: order_params[:no])
      order_params[:sales_attributes].each do |key, value|
        product = Product.find_by(sid: value[:product_sid])
        sale_price = (value[:sale].is_a? Numeric) ?
          value[:sale] : product.suggested_price
        sale = Sale.create(order_no: order.no, product_sid: value[:product_sid],
          sale: sale_price)
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
  end

  def update
  end

  def destroy
  end

  private

    def order_params
      params.require(:order).permit(:no, sales_attributes: [ :product_sid,
        :sale ])
    end
end
