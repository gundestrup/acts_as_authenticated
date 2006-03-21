require File.dirname(__FILE__) + '/../test_helper'
require '<%= controller_file_name %>_controller'

# Re-raise errors caught by the controller.
class <%= controller_class_name %>Controller; def rescue_action(e) raise e end; end

class <%= controller_class_name %>ControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  include AuthenticatedTestHelper

  fixtures :<%= table_name %>

  def setup
    @controller = <%= controller_class_name %>Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    # for testing action mailer
    # @emails = ActionMailer::Base.deliveries 
    # @emails.clear
  end

  def test_should_login_and_redirect
    post :login, :login => 'quentin', :password => 'quentin'
    assert session[:<%= file_name %>]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'quentin', :password => 'bad password'
    assert_nil session[:<%= file_name %>]
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference <%= class_name %>, :count do
      create_<%= file_name %>
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference <%= class_name %>, :count do
      create_<%= file_name %>(:login => nil)
      assert assigns(:<%= file_name %>).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference <%= class_name %>, :count do
      create_<%= file_name %>(:password => nil)
      assert assigns(:<%= file_name %>).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference <%= class_name %>, :count do
      create_<%= file_name %>(:password_confirmation => nil)
      assert assigns(:<%= file_name %>).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference <%= class_name %>, :count do
      create_<%= file_name %>(:email => nil)
      assert assigns(:<%= file_name %>).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:<%= file_name %>]
    assert_response :redirect
  end

  # Uncomment if you're activating new user accounts
  # 
  # def test_should_activate_user
  #   assert_nil User.authenticate('arthur', 'arthur')
  #   get :activate, :id => users(:arthur).activation_code
  #   assert_equal <%= table_name %>(:arthur), <%= class_name %>.authenticate('arthur', 'arthur')
  # end
  # 
  # def test_should_activate_user_and_send_activation_email
  #   get :activate, :id => <%= table_name %>(:arthur).activation_code
  #   assert_equal 1, @emails.length
  #   assert(@emails.first.subject =~ /Your account has been activated/)
  #   assert(@emails.first.body    =~ /#{assigns(:<%= file_name %>).login}, your account has been activated/)
  # end
  # 
  # def test_should_send_activation_email_after_signup
  #   create_<%= file_name %>
  #   assert_equal 1, @emails.length
  #   assert(@emails.first.subject =~ /Please activate your new account/)
  #   assert(@emails.first.body    =~ /Username: quire/)
  #   assert(@emails.first.body    =~ /Password: quire/)
  #   assert(@emails.first.body    =~ /account\/activate\/#{assigns(:<%= file_name %>).activation_code}/)
  # end

  protected
  def create_<%= file_name %>(options = {})
    post :signup, :<%= file_name %> => { :login => 'quire', :email => 'quire@example.com', 
                             :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
