require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get load" do
    get admin_load_url
    assert_response :success
  end

end
