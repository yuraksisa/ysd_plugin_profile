require 'warden' unless defined?Warden
require 'ysd_md_profile' unless defined?Users::Profile

module WardenStrategy
  #
  # It's an strategy to allow anonymous users access to the system
  #
  class AnonymousWardenStrategy < Warden::Strategies::Base
    
    #
    # Check when the strategy is valid
    #
    # If there is no user connected in the system
    #
    def valid?

      (not session.has_key?(:created_user)) and (user.nil?)

    end
    
    #
    # Authenticate the user
    #
    def authenticate!
      
      # Create a fake 'anonymous' user
      _user = Users::Profile.new('anonymous', {:username => 'anonymous', :full_name => 'Anonymous', :superuser => false, :usergroups => ['anonymous']})

      puts "anonymous user authenticated!"

      success!(_user)

    end


  end #AnonymousWardenStrategy
end #AnonymousWardenStrategy