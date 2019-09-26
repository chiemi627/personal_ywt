require 'test_helper'

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    request.headers['Authorization'] = ActionController::HttpAuthentication::Basic.
    encode_credentials(ENV['PYWT_USER'], ENV['PYWT_PASS'])
  end
  
  # test "the truth" do
  #   assert true
  # end
end
