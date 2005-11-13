module AuthenticatedTestHelper
  def login_as(<%= file_name %>)
    @request.session[:<%= file_name %>] = <%= file_name %>s(<%= file_name %>)
  end

  def assert_requires_login(<%= file_name %> = nil, &block)
    login_as(<%= file_name %>) if <%= file_name %>
    block.call
    assert_response :redirect
  end

  def assert_accepts_login(<%= file_name %> = nil, &block)
    login_as(<%= file_name %>) if <%= file_name %>
    block.call
    assert_response :success
  end

  def assert_accepts_anonymous(&block)
    assert_accepts_login(nil, &block)
  end
end