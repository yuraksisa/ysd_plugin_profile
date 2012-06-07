require 'ysd-plugins' unless defined?Plugins::Plugin
require 'sinatra/ysd_plugin_profile_middleware'
require 'ysd_plugin_profile_extension'

Plugins::SinatraAppPlugin.register :profile do

   name=        'profile'
   author=      'yurak sisa'
   description= 'Integrate profiles'
   version=     '0.1'
   sinatra_extension Sinatra::Profile # Add translations for the integration in the system
   sinatra_extension Sinatra::YSD::Profile
   sinatra_extension Sinatra::YSD::ProfileManagement # Profile Management (Profile)
   sinatra_extension Sinatra::YSD::UserGroupManagement # Profile Management (Profile)
   sinatra_helper Sinatra::ProfileHelpers # Profile helpers
   hooker            Huasi::ProfileExtension
  
end