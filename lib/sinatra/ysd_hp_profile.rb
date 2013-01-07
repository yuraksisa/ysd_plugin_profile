require 'renders/ysd_profile_render'
module Sinatra
  #
  # Social helpers 
  #
  module ProfileHelpers
   
    #
    # Loads the profile page
    #
    def page_from_profile(profile, options={})

       profile_page = UI::Page.new(:title => profile.full_name, 
                                   :content => Renders::ProfileRender.new(profile, self).render(options[:locals]))
      
       page(profile_page, options) 

    end

    #
    # Returns the url that shows the profile photo
    #
    def profile_photo_url(profile)
        
        img = options.profile_default_photo

        if profile
          img = if (profile.photo_url_medium and profile.photo_url_medium.strip.length > 0)
                   profile.photo_url_medium
                else
                   (profile[:sex] == '1')?(options.profile_default_women_photo):(options.profile_default_men_photo)
                end          
        end

        return img

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