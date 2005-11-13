class <%= controller_class_name %>Controller < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller
  def login
    return unless request.post?
    set_current_<%= file_name %> <%= class_name %>.authenticate(params[:login], params[:password])
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
      flash[:notice] = "Signed up, wait for confirmation email"
    end
  end

  def activate
    @<%= file_name %> = <%= class_name %>.find_by_activation_code(params[:id])
    if @<%= file_name %> and @<%= file_name %>.activate
      set_current_<%= file_name %> @<%= file_name %>
      redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
      flash[:notice] = "Your <%= controller_file_name %> has been activated."
    end
  end

  def logout
    set_current_<%= file_name %> nil
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
  end
end