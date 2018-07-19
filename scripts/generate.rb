#!/usr/bin/env ruby
require 'forwardable'
require 'erb'

class TemplateGenerator
  ERB_TEMPLATE ||= ::File.read(::File.expand_path('../generate.html.erb', __FILE__)).freeze
  ERB_INSTANCE ||= ::ERB.new(ERB_TEMPLATE).freeze
  Context = Struct.new(:title, :intro, :body)

  def self.render(title:, intro:, body:)
    context_bindings = Context.new(title, intro, body).send(:binding)
    ERB_INSTANCE.result(context_bindings)
  end
end

class DirectoryIndexer

  FileInfo = Struct.new(:name, :size) do
    include Comparable
    def <=>(other)
      name <=> other.name
    end
  end

  extend Forwardable 
  def_delegators :@files, :each, :size, :[], :first, :last
  attr_reader :path, :pattern, :files

  def initialize(path, pattern = '*.mp3')
    @path = path
    @files = nil
    @pattern = pattern
    @files = load_files
  end

  private 

  def load_files
    files = []
    Dir.chdir(path) do 
      files << Dir.glob(pattern).map { |f| FileInfo.new(f, File.size(f)) }
    end
    files.flatten
  end
end

class IndexGenerator
  attr_reader :files, :title, :intro, :link_prefix, :filename_decorator_proc, :output, :list_name

  DEFAULT_INDEX_FILE = 'index.html'.freeze

  def initialize(files: [], 
                 title: 'Auto Generated Index', 
                 list_name: 'File Listing',
                 intro: '',
                 link_prefix: '',
                 filename_decorator_proc:)
    @files = files
    @title = title
    @intro = intro
    @output = nil
    @link_prefix = link_prefix
    @list_name = list_name
    @filename_decorator_proc = filename_decorator_proc
  end

  def render
    @output = TemplateGenerator.render(title: title, intro: intro, body: body)
  end

  def render_file(file = DEFAULT_INDEX_FILE)
    ::File.open(file, 'w') { |f| f.write(render) }
  end

  def body
    %Q[
    <div class="list-group">
       <a href="#" class="list-group-item active"><h4>#{list_name}</h4></a>
#{render_file_listing}
    </div>
    ]
  end

  private

  def render_file_listing
    output = ""
    files.sort.each do |file|
      output << ' ' * 4
      output << %Q(<a class="list-group-item mb-0" href="#{link_prefix}/#{file.name}"><h5>#{filename_decorator_proc[file]}</h5></a>) 
      output << "\n"
    end
    output
  end
end


filename_proc = ->(file) { 
   file_mb = sprintf "%.0f", file.size.to_f / 1024.to_f / 1024.to_f
   file.name.gsub(/poolside\./, 'poolside-').split('-').map(&:capitalize).join(' ').gsub(/Poolside /, 'Poolside &mdash; ') + " (#{file_mb}Mb)" }

files = DirectoryIndexer.new(File.expand_path('../', __FILE__)).files
generator = IndexGenerator.new(files: files, 
                               title: 'Frolic 2018 Poolside Sets', 
                               list_name: 'MP3 File Listing',
                               intro: 'Dear DJs! Below you will find two versions of your Poolside set: the (master) versions are 
                                       minimum processed - mostly levels and very light limiting using the Waves Ultramaximizer 3.
                                       The (remaster) set is where I applied some additional tweaks, such as EQ, or stereo spread on 
                                       some sets, and so on — they may or may not sound good to you, so please indicate which version
                                       you prefer.'.gsub(/\s{2,}/, ' '),
                               filename_decorator_proc: filename_proc,
                               link_prefix: '/d/frolic2018'
                              )

generator.render_file

puts "GENERATED FILE:"
puts "——————————————————————"

puts generator.output


