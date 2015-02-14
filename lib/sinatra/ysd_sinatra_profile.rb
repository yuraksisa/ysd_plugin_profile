module Sinatra
  module YSD
    #
    # Sinatra extension for managing profiles :
    #
    #  > signup
    #  > password forgotten
    #  > change password
    #  > view profile
    #  > edit our profile (form)
    #
    module Profile
      
      def self.registered(app)
               
        # Add the local folders to the views and translations     
        app.settings.views = Array(app.settings.views).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))       
       
        app.enable :logging
                         
        app.set :profile_default_photo, "/profile/img/man.jpg"
        app.set :profile_default_men_photo, "/profile/img/man.jpg"
        app.set :profile_default_women_photo, "/profile/img/woman.jpg"
                         
        # ===================== Public resources ===========================
          
        # --------------------- Forget password ------------------------------
        
        app.get "/profile/register" do
          load_page :profile_register
        end

        #
        # Password forgotten form 
        #
        app.get "/profile/password-forgotten" do
        
          load_page :password_forgotten
        
        end
        
        #
        # Password forgotten form POST
        #
        app.post "/profile/password-forgotten" do
          
          begin      
            Users::RegisteredProfile.reset_password!(params['email'])          
            load_page :sent_new_password
          rescue EmailNotExist
            logger.error("The email address #{params[:email]} does not exist")
            flash[:error] = t.profile_form.validation.mail_not_in_use_server(params['email'])
            load_page :password_forgotten
          rescue
            logger.error("Error reseting password #{params[:email]}: #{$!}")
            flash[:error] = t.password_forgotten.error
            load_page :password_forgotten
          end
          
        end
        
    
        # ===================== Protected resources ==========================
 
        
        # ---------------------- Change password -----------------------------

        #
        # Change your password (show the form)
        #
        app.get "/profile/change-password" do
        
           authorized! "/profile"
           load_page :change_password
           
        end
        
        #
        # Change your password (update)
        #
        app.post "/profile/change-password" do
        
           authorized! "/profile"
           
           begin
             profile = Users::RegisteredProfile.get(user.username)
             profile.change_password!(params['current_password'], params['password'])
             load_page :password_updated
           rescue PasswordNotValid
             flash[:error] = t.profile_form.validation.password_not_valid
             load_page :change_password
           rescue
             logger.error("Error changing password #{user.username}")
             flash[:error] = t.change_password.error
             load_page :change_password
           end
           
        end
 
        # ------------------------ Edit profile ------------------------------
    
        #
        # Edit our profile
        #
        app.get "/profile/edit" do
          
          authorized! "/profile"
          
          if user
            load_em_page(:profile_edit, :profile, false)            
          else
            status 404
          end
                
        end
                    
        # ===================== Utilities ==========================
      
        #
        # Serves static content from the extension
        #
        app.get "/profile/*" do
          
           serve_static_resource(request.path_info.gsub(/^\/profile/,''), File.join(File.dirname(__FILE__), '..', '..', 'static'), 'profile')
                      
        end
          
      end
            
    end # Social
  end # YSD
end # Sinatra