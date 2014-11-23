# encoding: UTF-8
require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener
require 'ysd_md_cms' unless defined? Site::Menu
require 'ysd_md_configuration' unless defined? SystemConfiguration::Variable
require 'ysd_md_profile' unless defined? Users::RegisteredProfile
require 'ysd_core_themes' unless defined? Themes::ThemeManager
require 'ysd_core_plugins' unless defined? Plugins::Plugin
require 'ysd_plugin_cms' unless defined? SiteRenders::MenuRender

#
# Huasi Profile Extension
#
module Huasi

  class ProfileExtension < Plugins::ViewListener

    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})
            
        SystemConfiguration::Variable.first_or_create(
          {:name => 'profile.default_group'},
          {:value => 'user', 
           :description => 'default user group(s)', 
           :module => :profile})
    
        # Create the login menu
        Site::Menu.first_or_create({:name => 'login'},
          {:title => 'Login', 
           :description => 'Menu de inicio', 
           :menu_items => [Site::MenuItem.new(:title => 'Log in', 
             :link_route => '/login', 
             :description => 'Pagina de login', 
             :weight => 0, 
             :module => :profile)]})
    
        # Create the default groups : staff and user
        
        staff_group = Users::Group.first_or_create({:group => 'staff'},
          {:name => 'Staff', :description => 'Web site staff'})
                                        
        user_group = Users::Group.first_or_create({:group => 'user'},
          {:name => 'User', :description => 'Web site user'})                                 

        anonymous_group = Users::Group.first_or_create({:group => 'anonymous'},
          {:name => 'Anonymous users', :description => 'Anonymous user'})
        
        # Creates the admin profile (default profile to admin the site)
        
        unless Users::RegisteredProfile.get('admin')                
          Users::RegisteredProfile.create_user({:username => 'admin', 
            :superuser => true, 
            :password => '1234', 
            :full_name => 'Administrator', 
            :usergroups => [staff_group]})                 
        end
                
    end
    

    # ========= Blocks =====================

    # Retrieve all the blocks defined in this module 
    # 
    # @param [Hash] context
    #   The context
    #
    # @return [Array]
    #   The blocks defined in the module
    #
    #   An array of Hash which the following keys:
    #
    #     :name         The name of the block
    #     :module_name  The name of the module which defines the block
    #     :theme        The theme
    #
    def block_list(context={})
    
      app = context[:app]
    
      [{:name => 'profile_menu',
        :module_name => :profile,
        :theme => Themes::ThemeManager.instance.selected_theme.name},
       {:name => 'profile_dropdown',
        :module_name => :profile,
        :theme => Themes::ThemeManager.instance.selected_theme.name},
       {:name => 'profile_login_button',
        :module_name => :profile,
        :theme => Themes::ThemeManager.instance.selected_theme.name},
       {:name => 'profile_register_button',
        :module_name => :profile,
        :theme => Themes::ThemeManager.instance.selected_theme.name}]
        
    end

    # Get a block representation 
    #
    # @param [Hash] context
    #   The context
    #
    # @param [String] block_name
    #   The name of the block
    #
    # @return [String]
    #   The representation of the block
    #    
    def block_view(context, block_name)
    
      app = context[:app]
        
      case block_name

        when 'profile_menu'
          
          if app.user

            # Defines the profile menu
            menu_account = Site::Menu.new({:name => 'profile_menu', 
                                           :title => 'Profile menu', 
                                           :description => 'Account menu',
                                           :language_in_routes => false})
          
            menu_item_account = Site::MenuItem.new({:title => app.user.full_name, 
                                                    :module => :profile,
                                                    :menu => menu_account})
          
            menu_item_account_my_profile = Site::MenuItem.new(
              {:title => app.t.profile_menu.profile, 
               :link_route => "/profile/edit", 
               :module => :profile, 
               :menu => menu_account,
               :parent => menu_item_account})      
                                                                 
            menu_item_account_configuration = Site::MenuItem.new(
              {:title => app.t.profile_menu.change_password, 
               :link_route => "/profile/change-password", 
               :module => :profile, 
               :menu => menu_account,
               :parent => menu_item_account})
                                                                
            menu_item_account_logout = Site::MenuItem.new(
              {:title => app.t.profile_menu.logout, 
               :link_route => "/logout", 
               :module => :profile, 
               :menu => menu_account,
               :parent => menu_item_account})
          
           
            menu_item_account.children << menu_item_account_my_profile
            menu_item_account.children << menu_item_account_configuration
            menu_item_account.children << menu_item_account_logout

            menu_account.menu_items << menu_item_account
            menu_account.menu_items << menu_item_account_my_profile
            menu_account.menu_items << menu_item_account_configuration
            menu_account.menu_items << menu_item_account_logout
                     
            # Render the menu
            menu_render = SiteRenders::MenuRender.new(menu_account, context)
          
            menu_render.render
          
          
          end
        
        when 'profile_dropdown'

           login_locals = {}
           login_locals.store(:show_create_account, false)
           login_locals.store(:show_password_forgotten, false)
           login_locals.store(:login_strategies, 
             Plugins::Plugin.plugin_invoke_all('login_strategy', 
             context).join(" ") || '')

           login_form = app.partial(:login, :locals => login_locals)

           locals = {}
           locals.store(:show_create_account, 
             SystemConfiguration::Variable.get_value('auth.create_account',
             'false').to_bool)
           locals.store(:show_password_forgotten, 
             SystemConfiguration::Variable.get_value('auth.show_password_forgotten',
             'false').to_bool)
           locals.store(:login_form, login_form)

           app.partial(:profile_dropdown, :locals => locals) 

        when 'profile_register_button'
           
           app.partial(:profile_register_button)

        when 'profile_login_button'

           app.partial(:profile_login_button) 

      end

    end

    # ========= Menu =====================
    
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]
       
      menu_items = [{:path => '/users',
                     :options => {:title => app.t.profile_admin_menu.profile_menu,
                                  :description => 'Users management', 
                                  :module => :profile,
                                  :weight => 7}},
                    {:path => '/users/profiles',
                     :options => {:title => app.t.profile_admin_menu.profile_management,
                                  :link_route => "/admin/profiles",
                                  :description => 'Manages the users: modify, assign groups.',
                                  :module => :profile,
                                  :weight => 6}},
                    {:path => '/users/groups',
                     :options => {:title => app.t.profile_admin_menu.usergroup_management,
                                  :link_route => "/admin/usergroups",
                                  :description => 'Manages the user groups: creation, modification.',
                                  :module => :profile,
                                  :weight => 5}}]
       menu_items
   
    end

    # ========= Resource declaration ============
    
    #
    # It retrieves the images declared in the module
    #
    def resource_images(context={})
      ['/profile/img/man.jpg',
       '/profile/img/man_small.jpg',
       '/profile/img/woman.jpg',
       '/profile/img/woman_small.jpg']
    end
 
    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [{:path => '/admin/profiles',
                 :regular_expression => /^\/admin\/profiles/,
                 :title => 'Users',
                 :description => 'Manages the users: modify, assign groups',
                 :fit => 1,
                 :module => :profile},
                {:path => '/admin/usergroups',
                 :regular_expression => /^\/admin\/usergroups/,
                 :title => 'User groups',
                 :description => 'Manages the user groups: creation, modification',
                 :fit => 1,
                 :module => :profile},   
                {:path => '/profile/signup',
                 :regular_expression => /^\/profile\/signup/,
                 :title => 'Sign up',
                 :description => 'Sign up process form for registering a new user in the system',
                 :fit => 1,
                 :module => :profile},
                {:path => '/profile/edit',
                 :regular_expression => /^\/profile\/edit/,
                 :title => 'Edit profile',
                 :description => 'Edit our profile',
                 :fit => 1,
                 :module => :profile},
                {:path => '/profile/change-password',
                 :regular_expression => /^\/profile\/change-password/,
                 :title => 'Change profile password',
                 :description => 'A form to change the user password',
                 :fit => 1,
                 :module => :profile},      
                {:path => '/profile/password-forgotten',
                 :regular_expression => /^\/profile\/password-forgotten/,
                 :title => 'Password forgotten',
                 :description => 'A form to reset the user password',
                 :fit => 1,
                 :module => :profile},                                                           
                 ]
    
    end     
  
  end #MailExtension
end #Social