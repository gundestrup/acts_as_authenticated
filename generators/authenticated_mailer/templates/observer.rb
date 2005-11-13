class UserObserver < ActiveRecord::Observer
  def before_save(user)
    @signup = user.new_record?
  end

  def after_save(user)
    UserNotifier.deliver_signup_notification(user) if @signup
    UserNotifier.deliver_activation(user) if user.recently_activated?
  end
end