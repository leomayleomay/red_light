require 'red_light/fancy_login'

module RedLight
  class Railtie < Rails::Railtie
    initializer "red_light.configure_rails_initialization" do |app|
      app.middleware.use RedLight::FancyLogin
    end
  end
end
