class <%= class_name %> < ActiveRecord::Base
  # Sample schema:
  #   create_table "users", :force => true do |t|
  #     t.column "login",            :string, :limit => 40
  #     t.column "email",            :string, :limit => 100
  #     t.column "crypted_password", :string, :limit => 40
  #     t.column "salt",             :string, :limit => 40
  #     t.column "activation_code",  :string, :limit => 40
  #     t.column "active",           :boolean
  #     t.column "created_at",       :datetime
  #     t.column "updated_at",       :datetime
  #   end
  #
  # If you wish to have a mailer, run:
  #
  #   ./script/generate auth_mailer user
  # 
  # Be sure to add the observer to the form login controller:
  #
  #   class AccountController < ActionController::Base
  #     uses_form_authentication
  #     observer :user_observer
  #   end
  acts_as_authenticated
end