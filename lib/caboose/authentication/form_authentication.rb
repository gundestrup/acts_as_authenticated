module Caboose
  module Authentication
    module FormAuthentication
      def self.included(base)
        base.extend(ClassMethods)
        base.send :cattr_accessor, :welcome_url_options
        base.send :cattr_accessor, :authentication_messages
        base.welcome_url_options = { :controller => '/account', :action => 'index' }
        base.authentication_messages = { 
          :login    => "Logged in successfully",
          :signup   => "Signed up, wait for confirmation email",
          :activate => "Your account has been activated.",
          :logout   => "You have been logged out."}
      end
      
      module ClassMethods
        # Sets this controller up with basic actions for authenticating users with a form-based login
        # and accepting signups.
        #
        # Options:
        #   :welcome_url_options :: #url_for options for the welcome page
        #   :authentication_messages :: Hash of the flash messages the controllers set.
        #     :login => successful login
        #     :signup => successful signup
        #     :activate => user account activated
        #     :logut => user logged out
        #
        def uses_form_authentication(options = {})
          include ControllerMethods
          set_form_welcome_options(options[:welcome_url_options]) if options[:welcome_url_options]
          return unless options[:authentication_messages]
          [:login, :signup, :activate, :logout].each do |action|
            next unless options[:authentication_messages][action]
            authentication_messages[action] = options[:authentication_messages][action]
          end
        end
      end
      
      def ControllerMethods
        def login
          return unless request.post?
          set_current_user User.authenticate(params[:login], params[:password])
          if current_user
            redirect_back_or_default(welcome_url_options)
            flash[:notice] = authentication_messages[:login]
          end
        end

        def signup
          @user = User.new(params[:user])
          return unless request.post?
          if @user.save
            redirect_back_or_default(welcome_url_options)
            flash[:notice] = authentication_messages[:signup]
          end
        end

        def activate
          @user = User.find_by_activation_code(params[:id])
          if @user and @user.activate
            set_current_user @user
            redirect_back_or_default(welcome_url_options)
            flash[:notice] = authentication_messages[:activate]
          end
        end

        def logout
          set_current_user nil
          flash[:notice] = authentication_messages[:logout]
          redirect_back_or_default(welcome_url_options)
        end
      end
    end
  end
end