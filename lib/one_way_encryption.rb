require 'digest/sha1'
module RailsAuthentication
  class OneWayEncryption
    # Encrypts the model's password in the after_validation callback
    def before_save(model)
      return unless model.password
      model.crypted_password = self.class.encrypt(model.password, model.salt)
    end

    class << self
      # Encrypts some data with the salt.
      def encrypt(password, salt)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end

      # Sets this class up as the encryptor for the authenticated model
      def attach(model_class)
        model_class.class_eval do
          cattr_accessor :encryptor

          def salt
            self.salt = Digest::SHA1.hexdigest(Time.now.to_s) unless attribute_present?('salt')
            read_attribute 'salt'
          end

          def encrypt(data)
            encryptor.encrypt(data, salt)
          end
        end

        model_class.encryptor = self
        model_class.before_save self.new
      end
    end
  end
end