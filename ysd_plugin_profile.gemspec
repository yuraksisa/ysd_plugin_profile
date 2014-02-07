Gem::Specification.new do |s|
  s.name    = "ysd_plugin_profile"
  s.version = "0.1.30"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-02-28"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*'] 
  s.description = "Plugin for profiles management"
  s.summary = "Plugin for profiles management"
  
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "warden"
  s.add_runtime_dependency "sinatra-r18n"

  s.add_runtime_dependency "ysd_yito_core"
  s.add_runtime_dependency "ysd_yito_js"

  s.add_runtime_dependency "ysd_core_plugins"
  s.add_runtime_dependency "ysd_core_themes"
  
  s.add_runtime_dependency "ysd_md_profile"
  s.add_runtime_dependency "ysd_md_cms"  
  s.add_runtime_dependency "ysd_md_configuration"

  s.add_runtime_dependency "ysd_plugin_cms"        # Menu render

  s.add_runtime_dependency "ysd_service_template"
  s.add_runtime_dependency "ysd_service_postal"

end