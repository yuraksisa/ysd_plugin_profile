require 'ui/ysd_ui_entity_aspect_render' unless defined?UI::EntityAspectRender

module Renders
  #
  # It's responsible of rendering a profile
  #
  class ProfileRender

      attr_reader :profile, :context, :display

      def initialize(profile, context={}, display=nil)
        @profile = profile
        @context = context
        @display = display
      end

      def render(locals={})
        
        result = ''

        if profile_template_path = find_template
        
         template = Tilt.new(profile_template_path)
         
         profile_locals = {}
         profile_locals.merge!(locals) unless locals.nil?
         profile_locals.merge!(profile_extensions)
         profile_locals.merge!(profile_complements)
         profile_locals.merge!({:element => profile, :profile => profile})

         result = template.render(context, profile_locals)

         if String.method_defined?(:force_encoding)
           result.force_encoding('utf-8')
         end

        else
          puts "Template not found render-profile.erb"
        end

        return result

      end

      private
      
      #
      # Get the profile extensions (defined in plugins)
      #
      def profile_extensions
        
        profile_action = ''
        profile_not_owner_action = ''
        profile_data = ''
        profile_action_extension = ''
        profile_not_owner_action_extension = ''

        profile_action << context.call_hook(:profile_action, {:app => context}, profile)
        profile_not_owner_action << context.call_hook(:profile_not_owner_action, {:app => context}, profile)
        profile_data << context.call_hook(:profile, {:app => context}, profile)
        profile_action_extension << context.call_hook(:profile_action_extension, {:app => context}, profile)
        profile_not_owner_action_extension << context.call_hook(:profile_not_owner_action_extension, {:app => context}, profile)

        if String.method_defined?(:force_encoding)
          profile_action.force_encoding('utf-8')
          profile_not_owner_action.force_encoding('utf-8')
          profile_data.force_encoding('utf-8')
          profile_action_extension.force_encoding('utf-8')
          profile_not_owner_action_extension.force_encoding('utf-8')        
        end

        complements = {}
        complements.store(:profile_action, profile_action)
        complements.store(:profile_not_owner_action, profile_not_owner_action)
        complements.store(:profile_data, profile_data)
        complements.store(:profile_action_extension, profile_action_extension)
        complements.store(:profile_not_owner_action_extension, profile_not_owner_action_extension)

        return complements

      end
      
      #
      # Get the profile complements (defined on aspects)
      #
      def profile_complements

       context.render_entity_aspects(profile, :profile)

      end


      # Finds the template to render the content
      #
      # @param [String] resource_name
      #   The name of the template
      #
      def find_template
         
         template_name = "render-profile"
         template_name << "-#{display}" unless display.nil?

         # Search in theme path
         profile_template_path = Themes::ThemeManager.instance.selected_theme.resource_path("#{template_name}.erb",'template','profile') 
         
         # Search in the project
         if not profile_template_path
           path = context.get_path(template_name)                            
           profile_template_path = path if not path.nil? and File.exist?(path)
         end
         
         return profile_template_path
         
      end

  end
end