Gem::Specification.new do |s|
  s.name    = "ysd_plugin_profile"
  s.version = "0.1"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-02-28"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb','views/**/*.erb','i18n/**/*.yml','static/**/*.*'] 
  s.description = "Plugin for profiles management"
  s.summary = "Plugin for profiles management"
  
  s.add_runtime_dependency "ysd_core_plugins"
end