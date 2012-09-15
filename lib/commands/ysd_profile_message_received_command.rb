require 'ysd-md-profile' unless defined?Profile
require 'json' unless defined?JSON
require 'ysd_service_template' unless defined?TemplateService
require 'ysd_service_postal' unless defined?PostalService
require 'sinatra/r18n' unless defined?R18n

# -----------------------------------------------------------------------
# Process the mail_received event
# -----------------------------------------------------------------------
#  It sends a notification email to the user
# -----------------------------------------------------------------------
class ProfileMessageReceivedBusinessEventCommand < BusinessEvents::BusinessEventCommand
      include R18n::Helpers 
      
  def execute
      
      data = JSON.parse(business_event.data)
      
      # Loads the profile
      profile = Users::Profile.get(data['mailbox'])
              
      if profile and profile[:email] and profile[:email].strip.length > 0  
        
        body = TemplateService::TemplateBuilder.build('profile_message_received', data, {:locale => profile[:preferred_language]})
        
        PostalService.post(:to => profile[:email], 
                           :subject => t.social.message_received_subject, 
                           :body => body)  
      
      else
        puts "There is not an user #{mailbox} or the profile has not email"
      end
  
  end

end