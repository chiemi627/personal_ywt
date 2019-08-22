require 'test_helper'

class RetroControllerTest < ActionDispatch::IntegrationTest
  test "should get showall" do
    get retro_showall_url
    assert_response :success
  end

end
