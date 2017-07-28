require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  def setup
    @existing_product = products(:soap)
    @product = Product.new(sid: "SID-001",
      name: "Product Name",
      description: "This is a product description.",
      suggested_price: 99.99)
  end

  test "preconditions should be green" do
    assert @product.valid?
  end

  test "sid should be present" do
    @product.sid = nil
    assert_not @product.valid?
  end

  test "sid should not be blank" do
    blanks = [ "", " ", "   " ]
    blanks.each do |blank|
      @product.sid = blank
      assert_not @product.valid?
    end
  end

  test "sid should be unique" do
    assert Product.exists?(sid: @existing_product.sid)
    @product.sid = @existing_product.sid
    assert_not @product.valid?
  end

  test "sid should not contain leading or trailing whitespaces" do
    invalid_sids = [ " #{@product.sid}", "#{@product.sid} " ]
    invalid_sids.each do |sid|
      @product.sid = sid
      assert_not @product.valid?
    end
  end

  test "name should not be blank" do
    blanks = [ nil, "", " ", "  " ]
    blanks.each do |blank|
      @product.name = blank
      assert_not @product.valid?
    end
  end

  test "name should not contain leading and trailing whitespaces" do
    whitespaces = [ " #{@product.name}", "#{@product.name} " ]
    whitespaces.each do |name|
      @product.name = name
      assert_not @product.valid?
    end
  end

  test "name should be at least more than one character long" do
    @product.name = ""
    assert_not @product.valid?
    @product.name = "a"
    assert @product.valid?
  end

  test "description should not be shit" do
    @product.description = "This is a shitty description..."
    assert @product.description.include?("shit")
  end

  test "valid suggested_price" do
    suggested_prices = [ 9.9, 100, 1, 0, 0.0, 0.001 ]
    suggested_prices.each do |price|
      @product.suggested_price = price
      assert @product.valid?
    end
  end

  test "saving invalid suggested_price" do
    invalid_prices = [
      -1,
      -0.99
    ]
    invalid_prices.each do |price|
      @product.suggested_price = price
      assert_no_difference 'Product.count' do
        @product.save
      end
    end
  end
end
