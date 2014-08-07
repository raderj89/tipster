Airbrake.configure do |config|
  config.api_key = '1f3959aa63eb1022c2693d39ba391335'
  config.host    = 'e.nycdevshop.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.environment_name = Rails.env.production? ? `hostname` : Rails.env
end
