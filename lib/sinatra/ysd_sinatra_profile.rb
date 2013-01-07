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
                         
        app.set :profile_allow_create_account, true 
        app.set :profile_default_photo, "/profile/img/man.jpg"
        app.set :profile_default_men_photo, "/profile/img/man.jpg"
        app.set :profile_default_women_photo, "/profile/img/woman.jpg"
                         
        # ===================== Public resources ===========================
        
        # ---------------- Signup for a new account ------------------------
        
        #
        # Signup form
        #
        app.get "/profile/signup" do
    
          @method="POST"
          @action="/profile/signup"
          load_page(:profile_form, :locals => { :photo_album => SystemConfiguration::Variable.get_value('profile_album_name'), 
                                                :photo_width => SystemConfiguration::Variable.get_value('profile_album_photo_width'), 
                                                :photo_height => SystemConfiguration::Variable.get_value('profile_album_photo_height'),
                                                :photo_accept => SystemConfiguration::Variable.get_value('photo_media_accept'),
                                                :photo_max_size => SystemConfiguration::Variable.get_value('photo_max_size').to_i})
    
        end
       
        # --------------------- Forget password ------------------------------
        
        #
        # Forget password form
        #
        app.get "/profile/password-forgotten" do
        
          load_page :password_forgotten
        
        end
        
        #
        # Forget password
        #
        app.post "/profile/password-forgotten" do
          
          begin      
            Users::Profile.reset_password!(params['email'])          
            load_page :sent_new_password
          rescue EmailNotExist
            puts "The email address #{params['email']} does not exist"
            flash[:error] = t.profile_form.validation.mail_not_in_use_server(params['email'])
            load_page :password_forgotten
          rescue
            puts "Error reseting password : #{$!}"
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
           
           # Change the use password
           begin
             profile = Users::Profile.get(user[:username])
             profile.change_password!(params['current_password'], params['password'])
             load_page :password_updated
           rescue PasswordNotValid
             flash[:error] = t.profile_form.validation.password_not_valid
             load_page :change_password
           rescue
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
            locals = {}
            load_em_page(:profile_edit, :profile, false, :locals => locals)            
          else
            status 404
          end
                
        end
        
        #
        # Shows our profile
        #
        app.get "/profile" do
    
          authorized! "/profile"
       
          if profile = user
            page_from_profile(profile)
          else
            request.logger.error "#{request.path_info} Recurso no encontrado"
            status 404
          end
      
        end    
    
        # -------------------- Show other profile ----------------------------
    
        #
        # Shows a profile
        #
        app.get "/profile/:id" do
    
          authorized! "/profile"
       
          if profile = Users::Profile.get(params[:id])
             page_from_profile(profile)
          else
            request.logger.error "#{request.path_info} Recurso no encontrado"
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