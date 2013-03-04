
module Sinatra
  #
  # Profile helpers 
  #
  module ProfileHelpers
   
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
       
  end
end