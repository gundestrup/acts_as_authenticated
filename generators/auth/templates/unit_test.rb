require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  fixtures :<%= table_name %>

  def test_should_create_<%= file_name %>
    assert create_<%= file_name %>.valid?
  end

  def test_should_require_login
    u = create_<%= file_name %>(:login => nil)
    assert u.errors.on(:login)
  end

  def test_should_require_password
    u = create_<%= file_name %>(:password => nil)
    assert u.errors.on(:password)
  end

  def test_should_require_password_confirmation
    u = create_<%= file_name %>(:password_confirmation => nil)
    assert u.errors.on(:password_confirmation)
  end

  def test_should_require_email
    u = create_<%= file_name %>(:email => nil)
    assert u.errors.on(:email)
  end

  def test_should_reset_password
    <%= table_name %>(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    <%= table_name %>(:quentin).update_attribute(:login, 'quentin2')
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin2', 'quentin')
  end

  def test_should_authenticate_<%= file_name %>
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin', 'quentin')
  end

  protected
  def create_<%= file_name %>(options = {})
    <%= class_name %>.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end
end
