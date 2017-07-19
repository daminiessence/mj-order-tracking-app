require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "a[href=?]", root_path
  end

  test "should get about" do
    get root_path
    assert_response :success
    assert_select "a[href=?]", about_path
  end
end
