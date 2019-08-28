require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should be valid" do
    user = User.new(name:"chiemi",email:"chiemi@a.tsukuba-tech.ac.jp",password:"aaa",password_confirmation:"aaa")
    user.valid?
    puts user.category
    puts user.errors.full_messages.join(",")
    assert user.valid?
  end
end
