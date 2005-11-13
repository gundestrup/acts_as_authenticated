class AuthenticatedTestHelper
  def login_as(user)
    @request.session[:user] = users(user)
  end

  def assert_requires_login(user = nil, &block)
    login_as(user) if user
    block.call
    assert_response :redirect
  end

  def assert_accepts_login(user = nil, &block)
    login_as(user) if user
    block.call
    assert_response :success
  end

  def assert_accepts_anonymous(&block)
    assert_accepts_login(nil, &block)
  end
end