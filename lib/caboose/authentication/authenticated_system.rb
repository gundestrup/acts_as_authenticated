module Caboose
  module Authentication
    module AuthenticatedSystem 
      protected
      def logged_in?
        !session[:user].nil?
      end
  
      # accesses the current user from the session.
      # overwrite this to set how the current user is retrieved from the session.
      # To store just the ID and grab the user on each request:
      #
      #   def current_user
      #     @current_user ||= User.find_by_id(session[:user])
      #   end
      def current_user
        session[:user]
      end

      # store the given user in the session.  overwrite this to set how
      # users are stored in the session.  To store the ID, do:
      #
      #   def current_user=(new_user)
      #     session[:user] = new_user.id
      #     @current_user = new_user
      #   end
      def current_user=(new_user)
        session[:user] = new_user
      end

      alias_method :set_current_user, :current_user=

      # overwrite this if you want to restrict access to only a few actions
      # or if you want to check if the user has the correct rights  
      # example:
      #
      #  # only allow nonbobs
      #  def authorize?(user)
      #    user.login != "bob"
      #  end
      def authorized?(user)
         true
      end
  
      # overwrite this method if you only want to protect certain actions of the controller
      # example:
      # 
      #  # don't protect the login and the about method
      #  def protect?(action)
      #    if ['action', 'about'].include?(action)
      #       return false
      #    else
      #       return true
      #    end
      #  end
      def protect?(action)
        (self.class.protected_actions || controller_actions).to_a.include?(action.to_s)
      end

      def controller_actions
        @controller_actions ||= public_methods - ApplicationController.new.public_methods
      end

      # login_required filter. Use the #login_required macro:
      #
      #   login_required
      #
      # if the controller should be under any rights management. 
      # for finer access control you can overwrite
      #   
      #   def authorize?(user)
      # 
      def login_required
        # skip login check if action is not protected
        return true unless protect?(action_name)

        # check if user is logged in and authorized
        return true if logged_in? and authorized?(current_user)

        # store current location so that we can 
        # come back after the user logged in
        store_location
  
        # call overwriteable reaction to unauthorized access
        access_denied and return false
      end

      # overwrite if you want to have special behavior in case the user is not authorized
      # to access the current operation. 
      # the default action is to redirect to the login screen
      # example use :
      # a popup window might just close itself for instance
      def access_denied
        redirect_to :controller=>"/account", :action =>"login"
      end  
  
      # store current uri in  the session.
      # we can return to this location by calling return_location
      def store_location
        session[:return_to] = request.request_uri
      end

      # move to the last store_location call or to the passed default one
      def redirect_back_or_default(default)
        session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
        session[:return_to] = nil
      end

      def self.included(base)
        base.class_eval do
          helper_method :current_user, :logged_in?
          cattr_accessor :protected_actions

          def self.login_required(*protected_actions)
            set_protected_actions(protected_actions) unless protected_actions.empty?
            before_filter :login_required
          end

          def self.accepts_anonymous
            define_method(:protect?) { |action| false }
          end
        end
      end
    end
  end
end