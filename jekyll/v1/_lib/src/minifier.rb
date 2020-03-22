require 'yui/compressor'

class Minifier

  SUPPORTED_EXTENSIONS = {
    css: { class: YUI::CssCompressor, options: {} },
    js:  { class: YUI::JavaScriptCompressor, options: {} }
  }

  class SourceFile < File
  end

  attr_accessor :source_file, :minifier

  def initialize(filename)
    self.source_file = SourceFile.new(filename)
    if File.exist?(filename)
      ext = File.extname(filename)
      ext_config = SUPPORTED_EXTENSIONS[ext.to_s.gsub(/\./, '').to_sym]
      if ext_config
        self.minifier = ext_config[:class].new(ext_config[:options])
      end
    end
  end



  def minify!
    return false unless self.minifier
    minified = false
    Tempfile.new('minifier').open do |f|
      f.write(minify)
      f.flush
      if f.size > 0
        puts "copying #{f.path} to #{source_file.path}"
        FileUtils.cp(f.path, source_file.path + '.min')
        minified = true
      end
      minified
    end
  end

  def minify
    return nil unless minifier
    minifier.new(source_file.read).compress
  end
end


