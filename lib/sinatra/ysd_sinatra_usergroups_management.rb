module Sinatra
  module YSD
    #
    # User group management
    #
    module UserGroupManagement
   
      def self.registered(app)
                   
        #
        # Profiles management page
        #
        app.get "/admin/usergroups?", :allowed_usergroups => ['staff']  do
          authorized! settings.failure_path
          load_page :usergroups_management
        end
              
      end
    
    end #UserGroups
  end #YSD
end #Sinatra