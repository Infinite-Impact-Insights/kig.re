# frozen_string_literal: true

require 'stringio'
require 'yaml'
require 'json'
require 'liquid/tag'
require 'pp'

class QuizTag < Liquid::Tag
  attr_reader :output, :input, :tokens, :tag_name, :data

  def initialize(tag_name, input, tokens)
    super
    @output = StringIO.new
    @input = input
    @tokens = tokens
    @tag_name = tag_name
    @data = parse_input(input)
  end

  def render(context)
    output.puts %Q(
      <pre>
        <code lang="ruby">
        #{data.pretty_inspect}
        </code>
      </pre>
    )
    context.stack { output.string }
  end

  def parse_input(tag_data)
    JSON.parse(tag_data)
  rescue ::JSON::ParserError
    YAML.safe_load(tag_data)
  rescue ::Psych::SyntaxError
    array = tag_data.split('|')
    Hash[array.each_slice(2).to_a]
  end

  def to_h
    {
      output: output.string,
      input: input,
      tokens: tokens,
      tag_name: tag_name
    }
  end

  def inspect
    to_h.inspect
  end
end

Liquid::Template.register_tag('quiz', QuizTag)
