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
#     observer :user_observer
#   end
class <%= class_name %> < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  no_crypted_password = Proc.new { |record| record.crypted_password.nil? }
  validates_uniqueness_of   :login, :email, :salt
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_length_of       :password, :within => 5..40, :allow_nil => true
  validates_presence_of     :login, :email
  validates_presence_of     :password, 
                            :password_confirmation,
                            :if => no_crypted_password
  validates_confirmation_of :password, :if => no_crypted_password
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :select => 'id, salt', :conditions => ['login = ? and active = ?', login, true]
    return nil unless u
    find :first, :conditions => ["id = ? AND crypted_password = ?", u.id, u.encrypt(password)]
  end

  # Encrypts some data with the salt.
  def encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:active => true)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  # before filter 
  def encrypt_password
    return unless password
    if new_record?
      self.activation_code = Digest::SHA1.hexdigest("--#{salt}--#{login}--")
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
    end
    self.crypted_password = encrypt(password)
  end
end