require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
Dotenv.load(".env.#{Sinatra::Base.environment}")
Dir['./config/initializers/*.rb', './app/*.rb'].sort.each do |file|
  require file
end
