require 'ysd_md_profile' unless defined?Users::Profile

module Sinatra
  module YSD
    #
    # REST API for profile management
    #
    module ProfileRESTApi
      
      def self.registered(app)
                      
        app.enable :logging                 
        app.set :profiles_page_size, 12
                         
        # ===================== Public resources ===========================
            
        #
        # Register a new profile (REST API)
        #
        app.post "/profile/signup" do
    
          request_profile = body_as_json(Users::RegisteredProfile).merge(
            {:preferred_language => (session[:locale] || 
             settings.default_locale) }) 
          profile = Users::RegisteredProfile.signup(request_profile)
                
          # Authenticates the new user      
          if authenticated?
            logout
          end      
          session.delete(:created_user) if session.has_key?(:created_user)
          session[:created_user] = the_profile
          authenticate
      
          status 200
          body "Done"
      
        end    
    
        #
        # Check if it doesn't exists a profile with this username (REST API)
        #
        # Returns false it exists (is not valid)
        #
        app.post "/profile/check-user-not-exist" do
    
          content_type :json
          Users::Profile.get(params['username'])?(false.to_json):(true.to_json)
      
        end
        
        #
        # Check if it doesn't exist a profile with this email (REST API)
        #
        # Returns true if it exists and false if it does not exist
        #
        app.post "/profile/check-email-not-exist" do
        
          content_type :json
          Users::Profile.email_registered?(params['email'])?(false.to_json):(true.to_json)
        
        end
        
        #
        # Check if it exists a profile with this email (REST API)
        #
        app.post "/profile/check-email-exists" do
          
          content_type :json
          Users::Profile.email_registered?(params['email'])?(true.to_json):(false.to_json)
          
        end
        
        # ===================== Protected resources ==========================
        
        #
        # Change password
        #
        # Check if the connected profile password matches the received
        #
        app.post "/profile/check-password" do
         
          authorized! "/profile"
          
          result = false.to_json 
          
          if params['password'] and profile = Users::RegisteredProfile.get(user[:username])
            result = profile.check_password(params['password'])?(true.to_json):(false.to_json)
          end
            
          content_type :json  
          result
        
        end         
       
        #
        # Get our profile
        #
        app.get "/userprofile" do

          authorized! "/profile"

          if user and profile = Users::Profile.get(user.username)
             status 200
             content_type :json
             profile.to_json
          else
             status 404
          end

        end

        #
        # Updates our profile (REST API)
        #
        app.put "/userprofile" do
    
          authorized! "/profile"
      
          profile_request = body_as_json(Users::RegisteredProfile)

          if profile = Users::Profile.get(user.username)
            profile.attributes=(profile_request)
            profile.save    
          end
          
          # Updates the session user 
          user.attributes=(profile_request)  

          status 200
          content_type :json
          profile.to_json

        end
        
      
        # 
        # Search profile (REST API) 
        #
        #
        ["/profiles",
         "/profiles/page/:page"].each do |path|
          app.post path do
                                                              
            authorized! "/profile"
            
            page = params[:page].to_i || 1
            limit = settings.profiles_page_size
            offset = (page-1) * settings.profiles_page_size

            data, total = Users::Profile.find_other_profiles(user.username, limit, offset)
                                                              
            content_type :json
            {:data => data, :summary => { :total => total }}.to_json
        
          end
        
        end
                
      end
            
    end # ProfileRESTApi
  end # YSD
end # Sinatra