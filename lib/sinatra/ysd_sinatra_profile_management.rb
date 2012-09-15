module Sinatra
  module YSD
    #
    # Profile (users) management
    #
    module ProfileManagement
   
      def self.registered(app)
              
        #
        # Profiles management page
        #
        app.get "/profile-management" do
          authorized! settings.failure_path
          load_page 'profiles_management'.to_sym
        end
            
      end
    
    end
  end
end