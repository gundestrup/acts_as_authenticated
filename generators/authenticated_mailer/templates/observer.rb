class <%= class_name %>Observer < ActiveRecord::Observer
  def before_save(<%= file_name %>)
    @signup = <%= file_name %>.new_record?
  end

  def after_save(<%= file_name %>)
    <%= class_name %>Notifier.deliver_signup_notification(<%= file_name %>) if @signup
    <%= class_name %>Notifier.deliver_activation(<%= file_name %>) if <%= file_name %>.recently_activated?
  end
end