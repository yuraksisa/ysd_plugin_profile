module Sinatra
  module YSD
    #
    # REST API profile (users) management
    #
    module ProfileManagementRESTApi
   
      def self.registered(app)
      
        puts "Registering ProfileManagementRESTApi"
              
       #
        # Retrieve users
        #
        app.get "/users" do
        
            data=Users::Profile.find_all(false)
            
            content_type :json
            data.to_json 
        
        end
        
        #
        # Users search
        #
        ["/users","/users/page/:page"].each do |path|
          app.post path do
        
            data, total = Users::Profile.find_all
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
                  
          end
        end
        
        #
        # Creates a user
        #  
        app.post "/user" do
        
          puts "Creating content"
          
          request.body.rewind
          profile_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new profile
          profile = Users::Profile.new(content_request['username'], content_request) 
          
          puts "creating profile : #{profile}"
          
          profile.create
          
          # Return          
          status 200
          content_type :json
          content.to_json          
        
        
        end
        
        #
        # Updates the user information
        #
        app.put "/user" do

          puts "Updating profile"
        
          request.body.rewind
          profile_request = JSON.parse(URI.unescape(request.body.read))
          
          # Updates an existing content          
          profile = Users::Profile.get(profile_request['username'])
          profile.attributes=(profile_request)
          
          puts "updating profile : #{profile}"
          
          profile.update
          
          # Return          
          content_type :json
          profile.to_json
        
        end
        
        app.delete "/user" do
        
        end
      
      end
    
    end
  end
end