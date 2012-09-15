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
        puts "authenticated (exists in session)"
        profile = session.delete(:created_user)
        success!(profile)        
      else                
        if profile = Users::Profile.login(request.params['username'], request.params['password'])
          puts "authenticated"
          success!(profile)
        else
          puts "not authenticated"
          fail!("User or password is incorrect")
        end
    
      end
    
    end

  end

end
