require 'warden' unless defined?(Warden)
require 'ysd-md-profile' unless defined?(Profile)

module ProfileWarden

  #
  # Warden Strategy for Social  
  #
  class ProfileWardenStrategy < Warden::Strategies::Base

    # Check if the request is valid
    #
    def valid?
      params['username'] || params['password'] || session[:created_user]
    end
  
    # Authenticate the user
    #
    def authenticate!
                     
      if session[:created_user]          
        profile = session.delete(:created_user)
        success!(profile)        
      else                
        if profile = Users::RegisteredProfile.login(request.params['username'], request.params['password'])
          profile.update_last_access
          success!(profile)
        else
          fail!("User or password is incorrect")
        end
    
      end
    
    end

  end

end
