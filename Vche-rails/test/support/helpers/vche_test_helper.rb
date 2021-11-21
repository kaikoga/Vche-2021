module VcheTestHelper
  # include Sorcery::TestHelpers::Rails::Integration
  def login_user(user)
    # post the login and follow through
    post login_path, params: { email: user.email, password: "kaikoga" }
    follow_redirect!
  end

  def logout_user(user)
    # post the login and follow through
    post logout_path
    follow_redirect!
  end
end
