require 'uri' unless defined?URI
require 'json' unless defined?JSON
require 'ysd_md_profile' unless defined?Users::Profile

module Sinatra
  module YSD
    #
    # REST API for User groups
    #
    module UserGroupManagementRESTApi
   
      def self.registered(app)
        
        #
        # Retrieve user groups [GET]
        #            
        app.get "/api/usergroups" do
            authorized! settings.failure_path
            data=Users::Group.all
            content_type :json
            data.to_json        
        end
        
        #
        # Retrive user groups [POST]
        #
        ["/api/usergroups","/api/usergroups/page/:page"].each do |path|
          app.post path, :allowed_usergroups => ['staff'] do
            authorized! settings.failure_path
            data=Users::Group.all
            begin
              total=Users::Group.count
            rescue
              total=Users::Group.all.length
            end
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Create a new user group
        #
        app.post "/api/usergroup", :allowed_usergroups => ['staff'] do
          
          authorized! settings.failure_path
           
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          usergroup = Users::Group.create(usergroup_request) 
                    
          status 200
          content_type :json
          usergroup.to_json          
        
        end
        
        #
        # Updates an user group
        #
        app.put "/api/usergroup", :allowed_usergroups => ['staff'] do
        
          authorized! settings.failure_path
        
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          usergroup = Users::Group.get(usergroup_request['group'])
          usergroup.attributes=(usergroup_request)
                    
          usergroup.save
          
          content_type :json
          usergroup.to_json
        
        end
        
        #
        # Deletes a user group
        #
        app.delete "/api/usergroup", :allowed_usergroups => ['staff'] do
        
        end
      
      end
    
    end #UserGroupManagementRESTApi
  end #YSD
end #Sinatra