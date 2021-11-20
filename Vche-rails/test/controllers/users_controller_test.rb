require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include VcheTestHelper

  setup do
    @user = users(:default)
    login_user(@user)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    logout_user(@user)

    get new_user_url
    assert_response :success
  end

  test "should create user" do
    logout_user(@user)

    assert_difference('User.count') do
      post users_url, params: {
        user: {
          email: 'foo',
          display_name: 'foo',
          visibility: :public,
          user_role: :user,
          primary_sns_url: 'https://twitter.com/foo',
          profile: 'foofoofoo',
          password: 'foo',
          password_confirmation: 'foo'
        }
      }
    end

    assert_redirected_to users_url
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  # test "should update user" do
  #   patch user_url(@user), params: { user: { crypted_password: @user.crypted_password, email: @user.email, salt: @user.salt } }
  #   assert_redirected_to user_url(@user)
  # end
  #
  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user)
  #   end
  #
  #   assert_redirected_to users_url
  # end
end
