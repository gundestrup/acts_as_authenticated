module RailsAuthentication
  module Act
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Sets up proper validations and encryptions so that the current model can be
      # used as a login model.  Uses SHA1 as the encryption scheme by default.
      #
      # Validations
      #
      # Option:
      #
      #   <tt>encryptor</tt>: sets the encryptor class used.  It takes an
      #   underscored string/symbol (:one_way_encryption by default).  An encryption 
      #   class should live in the ActsAsAuthenticated.  This method will try to require
      #   the class if it is not defined yet.
      def acts_as_authenticated(encryptor = :one_way_encryption)
        included_already = self.respond_to?(:authenticate)
        no_crypted_password = Proc.new { |record| record.crypted_password.nil? }
        unless included_already
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
          attr_accessor :password
          def self.authenticate(login, password)
            u = find :first, :select => 'id, salt', :conditions => ['login = ? and active = ?', login, true]
            return nil unless u
            find :first, :conditions => ["id = ? AND crypted_password = ?", u.id, u.encrypt(password)]
          end
          
          def self.encrypt(password, salt)
            encryptor.encrypt(password, u.salt)
          end
          
          def encrypt(password)
            self.class.encrypt(password, salt)
          end

          def create_activation_code
            self.activation_code = encrypt("--#{salt}--#{login}--")
          end

          def create_salt
            self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
          end
          
          def activate
            @activated = update_attributes :active => true
          end
        end

        encryptor_class = encryptor.to_s.classify.demodulize
        require(encryptor.to_s) unless RailsAuthentication.const_defined?(encryptor_class)
        RailsAuthentication::const_get(encryptor.to_s.classify.demodulize).attach(self)
      end
    end
  end
end

ActiveRecord::Base.send :include, RailsAuthentication::Act