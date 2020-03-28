# frozen_string_literal: true

require 'tty/box'
require 'tty/screen'
require 'tty/cursor'

module UIWidgets
  DEFAULTS = {
               width:   TTY::Screen.width,
               align:   :left,
               border:  :light,
               padding: [0, 1, 0, 1],
               style:   {
                 fg:     :bright_yellow,
                 border: {
                   fg: :bright_yellow,
                 }
               }
             }.freeze

  def line
    ('—' * 80).yellow
  end

  def default_box_options(color = nil)
    options = DEFAULTS.dup

    if color
      options[:style][:fg]          = color
      options[:style][:border][:fg] = color
    end

    options
  end

  def error(*args)
    print TTY::Box.error(args.join("\n"), **default_box_options)
  end

  def warn(*args)
    print TTY::Box.warn(args.join("\n"), **default_box_options(:bright_yellow))
  end

  def info(*args)
    print TTY::Box.info(args.join("\n"), **default_box_options(:bright_green))
  end

  def cursor(method = nil, *args)
    (@cursor ||= TTY::Cursor).tap do |csr|
      if method
        print csr.send(method, *args)
      end
    end
  end

  def clear_screen!
    `reset`
  end

  BOX_OPTIONS = ->(title) do
    {
      title:   { top_center: title.nil? ? Time.new.to_s : title },
      padding: [0, 2, 0, 2]
    }
  end.freeze

  def text_box(title: nil, text: [], **options)
    cursor options[:cursor_action_before] if options[:cursor_action_before]

    print TTY::Box.frame(
      width: TTY::Screen.width,
      **default_box_options(:bright_yellow).merge(BOX_OPTIONS[title])
    ) do
      text.is_a?(Array) ? text.join("\n") : text.to_s
    end

    cursor options[:cursor_action_after] if options[:cursor_action_after]
  end
end
