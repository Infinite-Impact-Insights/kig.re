# frozen_string_literal: true

require 'json'

module Jekyll
  module Tags
    CLEAR_FIX = '<div class="clear-fix"></div>'

    class RenderTimeTag < Liquid::Tag
      def initialize(tag_name, text, tokens)
        super
        @text = text
      end

      def render(_context)
        "#{@text} #{Time.now}"
      end
    end

    class LinkToTag < Liquid::Tag
      def render(_context)
        %Q{+++<a name="##{@markup.gsub(/[" ]/, '')}"></a>+++}
      end
    end

    class MacroTag < Liquid::Tag
      MACROS = {
        read_more: %{&#8627; Keep reading &hellip;},
        clear_fix: CLEAR_FIX.to_s
      }.freeze

      attr_accessor :macro, :asciidoc

      def initialize(tag_name, macro, options)
        super
        @macro = macro.strip
        if options&.to_s && options.to_s.split(',').include?('asciidoc')
          self.asciidoc = true
        end
      end

      def render(context)
        (MACROS[@macro.to_sym] || unknown(@macro)).tap do |result|
          tag = result.to_s
          tag = "+++#{tag}+++" if asciidoc
          context.stack { tag }
          @result = result
        end
      end

      def unknown(what)
        <<~TAG
          <h1 class="unknown-macro">
            Unknown Macro Tag: #{what}
          </h1>
          <h2>
            Available Macros: #{MACROS.keys.join(', ')}
          </h2>
        TAG
      end
    end

    # Generates the following output:
    # <a href="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg" data-lightbox="enclosures" data-title="Observer First Module">
    #    <img src="https://raw.githubusercontent.com/kigster/Borat/master/images/module-observer/Observer-Final-SinglePCB-HandMade.jpg">
    # </a>
    class LightboxImageTag < Liquid::Tag
      attr_accessor :group, :url, :title, :css_class_anchor, :css_class_image, :asciidoc, :clear

      def initialize(tag_name, markup, options = {})
        super
        options = JSON.parse(markup.gsub("'", '"').gsub('=>', ':'))
        options.keys.each do |k|
          options[k.to_sym] = options[k]
          options.delete(k.to_s)
        end

        self.clear            = options[:clear]
        self.asciidoc         = options[:asciidoc]
        self.url              = options[:url]
        self.title            = options[:title] || ''
        self.group            = options[:group] || 'default-group'
        self.css_class_anchor = options[:a_class] || 'lightbox-anchor'
        self.css_class_image  = options[:img_class] || 'lightbox-img'
      end

      def render(context)
        tag = <<~HTML
          <a href="#{image_url}" class="#{css_class_anchor}"
           data-lightbox="#{group}"
           data-title="#{title}"><img
             class="#{css_class_image}"
             src="#{image_url}"/></a>
        HTML

        case clear
        when 'before'
          tag = CLEAR_FIX + tag
        when 'after'
          tag += CLEAR_FIX
        end

        if asciidoc
          tag = "+++#{tag}+++"
        end

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

Liquid::Template.register_tag('link_to', Jekyll::Tags::LinkToTag)
Liquid::Template.register_tag('render_time', Jekyll::Tags::RenderTimeTag)
Liquid::Template.register_tag('lightbox_image', Jekyll::Tags::LightboxImageTag)
Liquid::Template.register_tag('macro', Jekyll::Tags::MacroTag)
