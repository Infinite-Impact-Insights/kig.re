# frozen_string_literal: true

require 'tty/box'
require 'tty/screen'
require 'tty/cursor'

module UIWidgets
  def line
    ('—' * 80).yellow
  end

  def error(*args)
    print TTY::Box.error(args.join("\n"),
                         width:   TTY::Screen.width,
                         border:  :light,
                         padding: [0, 1, 0, 1])
  end

  def warn(*args)
    print TTY::Box.warn(args.join("\n"),
                        width:   TTY::Screen.width,
                        border:  :light,
                        padding: [0, 1, 0, 1],
                        style:   {
                          bg: :black,
                          fg: :bright_yellow
                        })
  end

  def info(*args)
    print TTY::Box.info(args.join("\n"),
                        width:   TTY::Screen.width,
                        border:  :light,
                        padding: [0, 1, 0, 1],
                        style:   {
                          bg:     :black,
                          fg:     :bright_blue,
                          border: {
                            bg: :black
                          }
                        })
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
    cursor :clear_screen
    cursor :move_to, 0, 0
  end

  def text_box(title: nil, text: [], **options)
    cursor options[:cursor_action_before] if options[:cursor_action_before]

    box = TTY::Box.frame(width:   TTY::Screen.width,
                         border:  :light,
                         align:   :left,
                         padding: [0, 2, 0, 2],
                         title:   { top_center: title.nil? ? Time.new.to_s : title},
                         style:   {
                           fg:     :bright_white,
                           border: {
                             fg: :bright_yellow,
                           }
                         }) do
      text.is_a?(Array) ? text.join("\n") : text.to_s
    end

    print box

    cursor options[:cursor_action_after] if options[:cursor_action_after]
  end
end
