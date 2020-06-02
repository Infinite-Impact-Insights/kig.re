# frozen_string_literal: true

require 'json'

# rubocop: disable Metrics/CyclomaticComplexity
# rubocop: disable Metrics/MethodLength
# rubocop: disable Style/Documentation
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
        %(+++<a name="#{@markup.gsub(/[" ]/, '')}"></a>+++)
      end
    end

    class IndexOff < Liquid::Tag
      def render(_context)
        '<!--noindex--><!--googleoff: all-->'
      end
    end

    class IndexOn < IndexOff
      def render(_context)
        '<!--googleon: all--><!--/noindex-->'
      end
    end

    class MacroTag < Liquid::Tag
      MACROS = {
        read_more: %(&#8627; Keep reading &hellip;),
        clear_fix: CLEAR_FIX.to_s
      }.freeze

      attr_accessor :macro, :asciidoc

      def initialize(tag_name, macro, options)
        super
        @macro = macro.strip
        self.asciidoc = true if options&.to_s && options.to_s.split(',').include?('asciidoc')
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
      attr_reader :group, :url, :title,
                  :a_class, :img_class, :a_style, :img_style,
                  :no_asciidoc, :clear

      ANCHOR_CLASS = 'lightbox-anchor'
      IMAGE_CLASS = 'lightbox-img'

      def initialize(tag_name, markup, options = {})
        super

        options = JSON.parse(markup.gsub("'", '"').gsub('=>', ':'))

        options.keys.each do |k|
          options[k.to_sym] = options[k]
          options.delete(k.to_s)
        end

        assign_parameters(options)
      end

      def render(context)
        tag = generate_tag_html

        case clear
        when 'before'
          tag = CLEAR_FIX + tag
        when 'after'
          tag += CLEAR_FIX
        end

        tag = "+++#{tag}+++" unless no_asciidoc

        tag.tap do |result|
          context.stack { result.to_s }
          @result = result
        end
      end

      def image_url
        @image_url ||= url.start_with?('http') ? url : "/assets/images/#{url}"
      end

      private

      def generate_tag_html
        %(<a href="#{image_url}"
             style="#{a_style}"
             class="#{a_class}"
             data-lightbox="#{group}"
             data-title="#{title}"><img
              class="#{img_class}"
              style="#{img_style}"
              src="#{image_url}"/></a>
        ).gsub(/[\s+]/, ' ').delete("\n")
      end

      def assign_parameters(options)
        @no_asciidoc      = options[:no_asciidoc]
        @clear            = options[:clear] || ''
        @url              = options[:url] || ''
        @title            = options[:title] || ''
        @group            = options[:group] || 'default-group'

        @a_class          = "#{ANCHOR_CLASS} #{options[:a_class]}"
        @a_style          = options[:a_style] || ''

        @img_class        = "#{IMAGE_CLASS} #{options[:img_class]}"
        @img_style        = options[:img_style] || ''
      end
    end
  end
end

Liquid::Template.register_tag('index_off', Jekyll::Tags::IndexOff)
Liquid::Template.register_tag('index_on', Jekyll::Tags::IndexOn)

Liquid::Template.register_tag('link_to', Jekyll::Tags::LinkToTag)
Liquid::Template.register_tag('render_time', Jekyll::Tags::RenderTimeTag)
Liquid::Template.register_tag('lightbox_image', Jekyll::Tags::LightboxImageTag)
Liquid::Template.register_tag('macro', Jekyll::Tags::MacroTag)

# rubocop: enable Metrics/CyclomaticComplexity
# rubocop: enable Metrics/MethodLength
# rubocop: enable Style/Documentation
