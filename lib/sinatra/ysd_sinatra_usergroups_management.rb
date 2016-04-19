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
          load_em_page :usergroups_management, nil, false
        end
              
      end
    
    end #UserGroups
  end #YSD
end #Sinatra