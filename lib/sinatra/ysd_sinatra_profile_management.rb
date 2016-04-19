require 'ysd_yito_core'

module Sinatra
  module YSD
    #
    # Profiles management
    #
    module ProfileManagement
   
      def self.registered(app)
              
        #
        # Profiles management page
        #
        app.get "/admin/profiles?", :allowed_usergroups => ['staff'] do
          authorized! settings.failure_path
          load_em_page :profiles_management, nil, false
        end
            
      end
    
    end
  end
end