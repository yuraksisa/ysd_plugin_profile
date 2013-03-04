require 'ysd_md_profile' unless defined?Users::Profile

module Sinatra
  module YSD
    #
    # REST API profile (users) management
    #
    module ProfileManagementRESTApi
   
      def self.registered(app)
              
        #
        # Retrieve users
        #
        app.get "/users" do        
          content_type :json
          Users::Profile.all.to_json     
        end
        
        #
        # Profiles search
        #
        ["/users","/users/page/:page"].each do |path|
          app.post path do
            data, total = Users::Profile.all_and_count
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          end
        end
        
        #
        # Creates a new profile
        #  
        app.post "/user" do
          
          profile = Users::RegisteredProfile.create(body_as_json(Users::RegisteredProfile))           
                    
          status 200
          content_type :json
          content.to_json          
        
        end
        
        #
        # Updates a profile
        #
        app.put "/user" do
          
          profile_request = body_as_json(Users::RegisteredProfile)

          if profile = Users::Profile.get(profile_request[:username])
            profile.attributes=(profile_request)
            profile.save
          end
          
          content_type :json
          profile.to_json
        
        end

        #
        # Deletes a profile
        #        
        app.delete "/user" do
        
          profile_request = body_as_json(Users::RegisteredProfile)

          if profile = Users::Profile.get(profile_request[:username])
            profile.destroy
          end
          
          content_type :json
          true.to_json

        end
      
      end
    
    end
  end
end