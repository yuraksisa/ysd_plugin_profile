require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Huasi Profile Extension
#
module Huasi

  class ProfileExtension < Plugins::ViewListener

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
        :theme => app.settings.theme}]
        
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
                                           :description => 'Account menu'})
          
            menu_item_account = Site::MenuItem.new({:title => app.user.full_name, 
                                                    :module => :profile,
                                                    :menu => menu_account})
          
            menu_item_account_my_profile = Site::MenuItem.new({:title => app.t.profile_menu.profile, 
                                                             :link_route => "#{app.settings.profile_prefix}", 
                                                             :module => :profile, 
                                                             :menu => menu_account,
                                                             :parent => menu_item_account})      
                                                                 
            menu_item_account_configuration = Site::MenuItem.new({:title => app.t.profile_menu.change_password, 
                                                                :link_route => "#{app.settings.profile_prefix}/change-password", 
                                                                :module => :profile, 
                                                                :menu => menu_account,
                                                                :parent => menu_item_account})
                                                                
            menu_item_account_logout = Site::MenuItem.new({:title => app.t.profile_menu.logout, 
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
                                  :link_route => "/profile-management",
                                  :description => 'Manages the users: modify, assign groups.',
                                  :module => :profile,
                                  :weight => 6}},
                    {:path => '/users/groups',
                     :options => {:title => app.t.profile_admin_menu.usergroup_management,
                                  :link_route => "/usergroup-management",
                                  :description => 'Manages the user groups: creation, modification.',
                                  :module => :profile,
                                  :weight => 5}}]
       menu_items
   
    end
  
    # ========= Routes ===================
    
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [{:path => '/profile-management',
                 :regular_expression => /^\/profile-management/,
                 :title => 'Users',
                 :description => 'Manages the users: modify, assign groups',
                 :fit => 1,
                 :module => :profile},
                {:path => '/usergroup-management',
                 :regular_expression => /^\/usergroup-management/,
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
                {:path => '/profile/:id',
                 :regular_expression => /^\/profile\/.+/,
                 :title => 'Show profile',
                 :description => 'Visit a user profile',
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