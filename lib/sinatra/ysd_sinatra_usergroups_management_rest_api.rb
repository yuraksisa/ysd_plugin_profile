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
                    
        app.get "/usergroups" do
            authorized! settings.failure_path
            data=Users::Group.all
            content_type :json
            data.to_json        
        end
        
        # Retrive the contents
        ["/usergroups","/usergroups/page/:page"].each do |path|
          app.post path do
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
        
        # Create a new content
        app.post "/usergroup" do
          
          authorized! settings.failure_path
           
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          usergroup = Users::Group.create(usergroup_request) 
                    
          status 200
          content_type :json
          usergroup.to_json          
        
        end
        
        # Updates a content
        app.put "/usergroup" do
        
          authorized! settings.failure_path
        
          request.body.rewind
          usergroup_request = JSON.parse(URI.unescape(request.body.read))
          
          usergroup = Users::Group.get(usergroup_request['group'])
          usergroup.attributes=(usergroup_request)
                    
          usergroup.save
          
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