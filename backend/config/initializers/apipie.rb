Apipie.configure do |config|
  config.app_name                = "Ship Sticks' Ruby/Rails Developer Challenge"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api/doc"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  # turn off localization
  config.translate               = false
  config.default_locale          = nil
end
