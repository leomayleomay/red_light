module RedLight
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copy red light configuration to your application."

      def copy_config
        template "red_light.rb", "config/initializers/red_light.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
