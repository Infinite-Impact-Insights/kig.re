# frozen_string_literal: true

require 'json'

module Jekyll
  module Tags
    class RenderTimeTag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(_context)
        "#{@text} #{Time.now}"
      end
    end

    class MacroTag < Liquid::Tag
      MACROS = {
          continue: %{<a href="#" name="continue"></a>},
          readmore: %{&#8627; Keep reading &hellip;},
          clearfix: %{<div class="clear-fix"></div>}
      }.freeze

      attr_accessor :macro

      def initialize(tag_name, macro, tokens)
        super
        @macro = macro.strip
      end

      def render(context)
        (MACROS[@macro.to_sym] || unknown(@macro)).tap do |result|
          context.stack { result.to_s }
          @result = result
        end
      end

      def unknown(what)
        %[<h1 style="background-color: #EE2000; color: white; text-shadow: 1px 1px 5px #551100;">Unknown Macro Tag: #{what}</h1><h2>Available Macros: #{MACROS.keys.join(', ')}</h2>]
      end
    end

    # Generates the following output:
    # <a href="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg" data-lightbox="enclosures" data-title="Observer First Module">
    #    <img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg">
    # </a>
    class LightboxImageTag < Liquid::Tag
      attr_accessor :group, :url, :title, :css_a_class, :css_img_class

      def initialize(tag_name, markup, options = {})
        super
        options = JSON.parse(markup.gsub("'", '"').gsub('=>', ':'))
        options.keys.each do |k|
          options[k.to_sym] = options[k]
          options.delete(k.to_s)
        end

        self.url           = options[:url]
        self.title         = options[:title] || ''
        self.group         = options[:group] || 'default-group'
        self.css_a_class   = options[:a_class] || 'lightbox-anchor'
        self.css_img_class = options[:img_class] || 'lightbox-img'
      end

      def render(context)
        tag = <<~HTML
          <a href="#{image_url}" class="#{css_a_class}"
           data-lightbox="#{group}"
           data-title="#{title}"><img
             class="#{css_img_class}"
             src="#{image_url}"/></a>
        HTML

        tag.tap do |result|
          context.stack { result.to_s }
          @result = result
        end
      end

      def image_url
        @image_url ||= url.start_with?('http') ? url : "/assets/images/#{url}"
      end
    end
  end
end

Liquid::Template.register_tag('render_time', Jekyll::Tags::RenderTimeTag)
Liquid::Template.register_tag('lightbox_image', Jekyll::Tags::LightboxImageTag)
Liquid::Template.register_tag('macro', Jekyll::Tags::MacroTag)
