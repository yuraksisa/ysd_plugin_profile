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
        app.get "/profile-management" do
          authorized! settings.failure_path
          load_page :profiles_management
        end
            
      end
    
    end
  end
end