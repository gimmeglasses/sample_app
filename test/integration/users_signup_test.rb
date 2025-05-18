require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  # failure in user signup
  test "invalid signup information" do
    # go to signup page
    get signup_path
    # User.count (count # of users)
    # expectation: no difference (# of users) after post methog in record below 
    assert_no_difference 'User.count' do
      # post method to create a new user
      post users_path, params: { user: {name:  "",
                                        email: "user@invalid",  # <- On Web browser, it will show "invalid email address", but rails will not check it.
                                        password:              "123",
                                        password_confirmation: "456" } }
    end
    # check if the response is unprocessable entity (422 error)
    assert_response :unprocessable_entity
    assert_template 'users/new'
  end

  # success in user signup
  test "successful signup" do
    # go to signup page
    get signup_path
    # User.count (count # of users)
    assert_difference 'User.count', 1 do
      # post method to create a new user
      post users_path, params: { user: { name:  "test uset",
                                         email: "test@example.com",
                                         password: "123456789",
                                         password_confirmation: "123456789" } }
    end
    # other tests should be written before follow_direct!
    follow_redirect!
      # GET /users/:id
      # "!" : 破壊的メソッド（一つ前の状態には戻れない）
    assert_template 'users/show'
  end
end
