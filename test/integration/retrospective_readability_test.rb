require 'test_helper'

class RetrospectiveReadabilityTest < ActionDispatch::IntegrationTest
  def setup
    @headers_authorization = ActionController::HttpAuthentication::Basic.encode_credentials(ENV['PYWT_USER'], ENV['PYWT_PASS'])
  end

  test "st1がチームt1の振り返りを見た時全員分見えて、t2の振り返りは何も見えない" do
    @user = users(:st1)
    post '/login', params: {session: {email: @user.email, password: 'password'}}, headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_redirected_to :root
    follow_redirect!
    get '/t/1', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:3        
    get '/t/2', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:0
  end

  test "st2がチームt1の振り返りを見た時2件見えて、t2の振り返りは0件見える" do
    @user = users(:st2)
    post '/login', params: {session: {email: @user.email, password: 'password'}}, headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_redirected_to :root
    follow_redirect!
    get '/t/1', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:3        
    get '/t/2', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:0
  end    

  test "st3がチームt1の振り返りを見た時1件だけ見えて、t2の振り返りは1件見える" do
    @user = users(:st3)
    post '/login', params: {session: {email: @user.email, password: 'password'}}, headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_redirected_to :root
    follow_redirect!
    get '/t/1', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:2        
    get '/t/2', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:2
  end    

  test "st4がチームt1の振り返りを見た時1件見えて、t2の振り返りは2件見える" do
    @user = users(:st4)
    post '/login', params: {session: {email: @user.email, password: 'password'}}, headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_redirected_to :root
    follow_redirect!
    get '/t/1', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:2        
    get '/t/2', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:3
  end    

  test "chiemiは全チームの振り返りを見れる" do
    @user = users(:chiemi)
    post '/login', params: {session: {email: @user.email, password: 'password'}}, headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_redirected_to :root
    get '/retro/latest', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:5
    get '/t/1', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:3        
    get '/t/2', headers: { "HTTP_AUTHORIZATION" => @headers_authorization }
    assert_select "tr", count:3
  end    
end
