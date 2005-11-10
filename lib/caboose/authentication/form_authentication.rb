module Caboose
  module Authentication
    module FormAuthentication
      def self.included(base)
        base.extend(ClassMethods)
        base.send :cattr_accessor, :form_welcome_options
      end
      
      module ClassMethods
        def uses_form_authentication(form_welcome_options = { :controller => '/account', :action => 'index' })
          include ControllerMethods
          set_form_welcome_options(form_welcome_options)
        end
      end
      
      def ControllerMethods
        def login
          return unless request.post?
          set_current_user User.authenticate(params[:login], params[:password])
          if current_user
            redirect_back_or_default(form_welcome_options)
            flash[:notice] = "Logged in successfully"
          end
        end

        def signup
          @user = User.new(params[:user])
          return unless request.post?
          if @user.save
            redirect_back_or_default(form_welcome_options)
            flash[:notice] = "Signed up, wait for confirmation email"
          end
        end

        def activate
          @user = User.find_by_activation_code(params[:id])
          if @user and @user.activate
            set_current_user @user
            redirect_back_or_default(form_welcome_options)
            flash[:notice] = "Your account has been activated."
          end
        end

        def logout
          set_current_user nil
          flash[:notice] = "You have been logged out."
          redirect_back_or_default(form_welcome_options)
        end
      end
    end
  end
end