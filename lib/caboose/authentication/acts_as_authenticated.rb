module Caboose
  module Authentication
    def self.included(base)
      base.extend(Act)
    end

    module Act
      # Sets up proper validations and encryptions so that the current model can be
      # used as a login model.  Uses SHA1 as the encryption scheme by default.
      #
      # Option:
      #
      #   <tt>encryptor</tt>: sets the encryptor class used.  It takes an
      #   underscored string/symbol (:one_way_encryption by default).  This method will try to require
      #   the class if it is not defined yet.
      def acts_as_authenticated(encryptor = :one_way_authentication)
        included_already = self.respond_to?(:authenticate)
        unless included_already
          no_crypted_password = Proc.new { |record| record.crypted_password.nil? }
          self.validates_uniqueness_of   :login, :email, :salt
          self.validates_length_of       :login,    :within => 3..40
          self.validates_length_of       :email,    :within => 3..100
          self.validates_length_of       :password, :within => 5..40, :allow_nil => true
          self.validates_presence_of     :login, :email
          self.validates_presence_of     :password, 
                                         :password_confirmation,
                                         :if => no_crypted_password
          self.validates_confirmation_of :password, :if => no_crypted_password
        end
  
        self.class_eval do
          # Virtual attribute for the unencrypted password
          attr_accessor :password
          
          # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
          def self.authenticate(login, password)
            u = find :first, :select => 'id, salt', :conditions => ['login = ? and active = ?', login, true]
            return nil unless u
            find :first, :conditions => ["id = ? AND crypted_password = ?", u.id, u.encrypt(password)]
          end
          
          # Encrypts a password with the given salt
          def self.encrypt(password, salt)
            encryptor.encrypt(password, u.salt)
          end

          # Encrypts the password with the user salt
          def encrypt(password)
            self.class.encrypt(password, salt)
          end

          # creates a hash of a unique activation code for a user.  This is used to activate the user
          def create_activation_code
            self.activation_code = encrypt("--#{salt}--#{login}--")
          end

          # creates a unique salt for the user.
          def create_salt
            self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
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
        end

        encryptor.to_s.classify.constantize.attach(self)
        #require("caboose/authentication/#{encryptor}") unless Caboose::Authentication.const_defined?(encryptor.to_s.classify.demodulize)
        #Caboose::Authentication.const_get(encryptor.to_s.classify.demodulize).attach(self)
      end
    end
  end
end