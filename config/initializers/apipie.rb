Apipie.configure do |config|
  config.app_name                = "Followers Api"
  config.app_info                = "Followers Api Documentation RC1"
  config.api_base_url            = "/api"
  config.doc_base_url            = ''
  config.validate                = false
  config.namespaced_resources    = true
  config.translate               = false

  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  config.copyright               = "Yana Rahadhian 2018"
  config.default_version         = "1.0"
end
