require 'red_light/fancy_login'

module RedLight
  class Railtie < Rails::Railtie
    initializer "red_light.configure_rails_initialization" do |app|
      ::RED_LIGHT_RULES = Hash.new([])

      Dir.glob("app/controllers/**/*_controller.rb").map do |entry|
        controller = File.basename(entry, ".rb").classify.constantize

        filter = controller._process_action_callbacks.select{ |callback|
          callback.filter == :authenticate_user!
        }.first

        next if filter.nil?

        controller_name = controller.to_s.underscore.split("_controller").first
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

      app.middleware.use RedLight::FancyLogin
    end
  end
end
