module Sinatra
  #
  # Social helpers 
  #
  module ProfileHelpers
   
    # Returns the url that shows the profile photo
    #
    #
    def profile_photo_url(profile)
            
        if profile
          img = 
            if (profile[:photo])
              media_url('/photo_gallery', profile[:photo], :medium)
            end   
                   
          unless img 
            img = (profile[:sex] == '1')?(options.profile_default_women_photo):(options.profile_default_men_photo)
          end
          
          img
          
        else
          options.profile_default_photo
        end
    
    end
       
    #
    # Render a social profile action button
    #
    # @param [Hash] option
    #   Information to render the button
    #   
    #
    def render_profile_action_button(option)
    
      profile_button = <<-PROFILE_BUTTON
         <div class="form-button"><a href="#{option[:link]}">#{option[:text]}</a></div>
      PROFILE_BUTTON
      
      if String.method_defined?(:encode)
        profile_button.encode!('UTF-8')
      end
      
      profile_button
      
    end
   
  end
end