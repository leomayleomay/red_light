# -*- encoding : utf-8 -*-

module RedLight
  class FancyLogin
    def initialize(app, rules)
      @app = app
      @rules = rules
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      @status, @headers, @response = @app.call(env)

      empty_response = (@response.is_a?(Array) && @response.size <= 1) ||
        !@response.respond_to?(:body) ||
        !@response.body.respond_to?(:empty?) ||
        @response.body.empty?

      return [@status, @headers, @response] if empty_response

      response_body = []
      @response.each do |part|
        # For the forms
        part.scan(/action="(.*?)"/).each do |form_action|
          form_action = form_action.first
          begin
            path = Rails.application.routes.recognize_path(form_action, :method => "post")
            controller = path[:controller]
            action = path[:action]

            if @rules[controller] && @rules[controller].include?(action)
              part.gsub!(/action="#{form_action}"/, "action='javascript:void(0);' rel='fancy_login'")
            end
          rescue ActionController::RoutingError => e
          end
        end

        # For the links
        part.scan(/href="\/(.*?)"/).each do |href|
          href = href.first
          begin
            path = Rails.application.routes.recognize_path(href)
            controller = path[:controller]
            action = path[:action]

            if @rules[controller] && @rules[controller].include?(action)
              href_regex = Regexp.compile(Regexp.escape('href="/'+href+'"'))
              part.gsub!(href_regex, "href='/#{href}' rel='fancy_login'")
            end
          rescue ActionController::RoutingError => e
          end
        end

        response_body << part
      end

      [@status, @headers, response_body]
    end
  end
end
