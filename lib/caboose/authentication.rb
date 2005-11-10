require 'caboose/authentication/acts_as_authenticated'
require 'caboose/authentication/authenticated_system'
require 'caboose/authentication/form_authentication'

ActiveRecord::Base.send     :include, Caboose::Authentication::Act
ActionController::Base.send :include, Caboose::Authentication::AuthenticatedSystem
ActionController::Base.send :include, Caboose::Authentication::FormAuthentication