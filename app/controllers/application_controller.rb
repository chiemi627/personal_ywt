class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :basic    
    private

    def basic
      authenticate_or_request_with_http_basic do |name, password|
        name == ENV['PYWT_USER'] && password == ENV['PYWT_PASS']
      end
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
end
