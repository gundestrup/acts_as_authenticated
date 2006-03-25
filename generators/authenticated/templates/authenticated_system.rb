module AuthenticatedSystem
  protected
  def logged_in?
    # Example of integration with account_location plugin
    # session[account_subdomain] == :authenticated && current_<%= file_name %>
    current_<%= file_name %>
  end

  # accesses the current <%= file_name %> from the session.
  # overwrite this to set how the current <%= file_name %> is retrieved from the session.
  # To store just the whole <%= file_name %> model in the session:
  #
  #   def current_<%= file_name %>
  #     session[:<%= file_name %>]
  #   end
  # 
  def current_<%= file_name %>
    @current_<%= file_name %> ||= session[:<%= file_name %>] ? <%= class_name %>.find_by_id(session[:<%= file_name %>]) : nil
  end

  # store the given <%= file_name %> in the session.  overwrite this to set how
  # <%= table_name %> are stored in the session.  To store the whole <%= file_name %> model, do:
  #
  #   def current_<%= file_name %>=(new_<%= file_name %>)
  #     session[:<%= file_name %>] = new_<%= file_name %>
  #   end
  # 
  def current_<%= file_name %>=(new_<%= file_name %>)
    # Example of integration with account_location plugin
    # session[account_subdomain] = new_<%= file_name %>.nil? ? nil : :authenticated
    session[:<%= file_name %>] = new_<%= file_name %>.nil? ? nil : new_<%= file_name %>.id
    @current_<%= file_name %> = new_<%= file_name %>
  end

  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the <%= file_name %> has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(<%= file_name %>)
  #    <%= file_name %>.login != "bob"
  #  end
  def authorized?(<%= file_name %>)
     true
  end

  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(action)
    true
  end

  # Example of integration with account_location plugin
  # def account?
  #   @account ||= Account.find_by_username(account_subdomain)
  # end
  # 
  # def account_required
  #   return true if account?
  #   redirect_to(:controller => '/<%= controller_file_name %>', :action => 'index') and return false
  # end

  # To require logins, use:
  #
  #   before_filter :login_required                            # restrict all actions
  #   before_filter :login_required, :only => [:edit, :update] # only restrict these actions
  # 
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  # 
  def login_required
    # skip login check if action is not protected
    return true unless protect?(action_name)

    # check if <%= file_name %> is logged in and authorized
    return true if logged_in? and authorized?(current_<%= file_name %>)

    # store current location so that we can 
    # come back after the <%= file_name %> logged in
    store_location

    # call overwriteable reaction to unauthorized access
    access_denied and return false
  end

  # overwrite if you want to have special behavior in case the <%= file_name %> is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller => '/<%= controller_file_name %>', :action => 'login'
  end  

  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
    session[:return_to] = request.request_uri
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end

  # adds ActionView helper methods
  def self.included(base)
    base.send :helper_method, :current_<%= file_name %>, :logged_in?
  end
end