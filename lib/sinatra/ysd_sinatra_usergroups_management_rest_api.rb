module Sinatra
  module YSD
    #
    # REST API for User groups
    #
    module UserGroupManagementRESTApi
   
      def self.registered(app)
                    
        app.get "/usergroups" do
            authorized! settings.failure_path
            data=Users::UserGroup.all
            content_type :json
            data.to_json        
        end
        
        # Retrive the contents
        ["/usergroups","/usergroups/page/:page"].each do |path|
          app.post path do
            authorized! settings.failure_path
            data=Users::UserGroup.all
            begin
              total=Users::UserGroup.count
            rescue
              total=Users::UserGroup.all.length
            end
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        # Create a new content
        app.post "/usergroup" do
          
          authorized! settings.failure_path
          
          puts "Creating usergroup"
           
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          # Creates the new content
          usergroup = Users::UserGroup.create(usergroup_request) 
          
          puts "created usergroup : #{usergroup}"
                    
          # Return          
          status 200
          content_type :json
          usergroup.to_json          
        
        end
        
        # Updates a content
        app.put "/usergroup" do
        
          authorized! settings.failure_path
          
          puts "Updating usergroup"
        
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          puts "usergroup : #{usergroup_request} #{usergroup_request.class.name}"
          
          # Creates the new content          
          usergroup = Users::UserGroup.get(usergroup_request['group'])
          usergroup.attributes=(usergroup_request)
          
          puts "updating usergroup : #{usergroup}"
          
          usergroup.save
          
          # Return          
          content_type :json
          usergroup.to_json
        
        
        end
        
        # Deletes a content
        app.delete "/usergroup" do
        
        end
      
      end
    
    end #UserGroupManagementRESTApi
  end #YSD
end #Sinatra