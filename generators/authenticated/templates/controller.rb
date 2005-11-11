class <%= controller_class_name %>Controller < ActionController::Base
  # Add <tt>login_required</tt> to a controller to restrict access:
  #
  #   # Restricts access on all actions
  #   login_required
  #
  #   # Restricts access for certain actions only
  #   login_require :edit, :update, :new, :create, :destroy
  #
  #   # Skip a login set by a parent controller
  #   skip_before_filter :login_required
  #
  # See Caboose::Authentication::AuthenticatedSystem for more options.
  uses_form_authentication
end