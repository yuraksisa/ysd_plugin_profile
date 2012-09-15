require 'ysd-md-profile' unless defined?Profile
require 'json' unless defined?JSON
require 'ysd_service_template' unless defined?TemplateService
require 'ysd_service_postal' unless defined?PostalService
require 'sinatra/r18n' unless defined?R18n

# -----------------------------------------------------------------------
# Process the profile_signup event
# -----------------------------------------------------------------------
#  It sends a wellcome email to the user
# -----------------------------------------------------------------------
class ProfileSignupBusinessEventCommand < BusinessEvents::BusinessEventCommand
      include R18n::Helpers 
      
  def execute
      
      data = JSON.parse(business_event.data)
      
      # Loads the profile
      profile = Users::Profile.get(data['username'])
              
      if profile[:email] and profile[:email].strip.length > 0  
        
        body = TemplateService::TemplateBuilder.build('wellcome', data, {:locale => profile[:preferred_language]})
        
        PostalService.post(:to => profile[:email], 
                           :subject => t.social.wellcome_mail_subject, 
                           :body => body)  
      
      else
        puts "The profile has not email"
      end
  
  end

end