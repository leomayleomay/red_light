require 'red_light/fancy_login'

module RedLight
  class Railtie < Rails::Railtie
    initializer "red_light.configure_rails_initialization" do |app|
      app.middleware.use RedLight::FancyLogin
    end

    ActiveSupport.on_load(:action_controller) do
      ::RED_LIGHT_RULES = Hash.new([])

      controllers = Dir.glob("app/controllers/**/*_controller.rb").map do |entry|
        File.basename(entry, ".rb").classify.constantize
      end

      controllers.each do |c|
        filter = c._process_action_callbacks.select{ |callback|
          callback.filter == :authenticate_user!
        }.first

        next if filter.nil?

        controller_name = c.to_s.underscore.split("_controller").first
        ::RED_LIGHT_RULES[controller_name] = Array(c.action_methods)

        options = filter.options
        if options[:only].present? && Array(options[:only]).any?
          ::RED_LIGHT_RULES[controller_name] = Array(options[:only]).map(&:to_s)
        end

        if options[:except].present? && Array(options[:except]).any?
          ::RED_LIGHT_RULES[controller_name] -= Array(options[:except]).map(&:to_s)
        end
      end

      ::RED_LIGHT_RULES.freeze
    end
  end
end
