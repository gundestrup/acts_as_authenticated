class <%= controller_class_name %>Controller < ApplicationController
  include AuthenticatedSystem
  # Be sure to include AuthenticationSystem in Application Controller instead
  # To require logins, use:
  #
  #   before_filter :login_required                            # restrict all actions
  #   before_filter :login_required, :only => [:edit, :update] # only restrict these actions
  # 
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? or <%= class_name %>.count > 0
  end

  def login
    return unless request.post?
    self.current_<%= file_name %> = <%= class_name %>.authenticate(params[:login], params[:password])
    if current_<%= file_name %>
      redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
    return unless request.post?
    if @<%= file_name %>.save
      redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
      flash[:notice] = "Thanks for signing up!"
    end
  end
  
  # Sample method for activating the current user
  #def activate
  #  @<%= file_name %> = <%= class_name %>.find_by_activation_code(params[:id])
  #  if @<%= file_name %> and @<%= file_name %>.activate
  #    self.current_<%= file_name %> = @<%= file_name %>
  #    redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
  #    flash[:notice] = "Your <%= controller_file_name %> has been activated."
  #  end
  #end

  def logout
    self.current_<%= file_name %> = nil
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
  end
end
