module RedLight
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Copy red light rules to your application."

      def copy_rules
        template "red_light_rules.rb", "config/initializers/red_light_rules.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
