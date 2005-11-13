class <%= class_name %>Notifier < ActionMailer::Base
  def signup_notification(<%= class_path %>)
    setup_email(<%= class_path %>)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://YOURSITE/account/activate/#{<%= class_path %>.activation_code}"
  end
  
  def activation(<%= class_path %>)
    setup_email(<%= class_path %>)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end
  
  protected
  def setup_email(<%= class_path %>)
    @recipients  = "#{<%= class_path %>.email}"
    @from        = "ADMINEMAIL"
    @subject     = "[YOURSITE] "
    @sent_on     = Time.now
    @body[:<%= class_path %>] = <%= class_path %>
  end
end
