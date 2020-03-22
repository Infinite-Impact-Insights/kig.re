require 'yui/compressor'

class FileMinifier
  class NoMinifierForThisType < StandardError;
  end

  SUPPORTED_EXTENSIONS = {
    css: { class: YUI::CssCompressor, options: {} },
  }

  attr_accessor :ext, :source, :target, :minifier

  def initialize(filename)
    raise ArgumentError, "file #{filename} does not exist" unless File.exist?(filename)
    self.ext    = File.extname(filename).gsub(/\./, '')
    self.source = filename
    self.target = source + '.min'

    compressor_h = SUPPORTED_EXTENSIONS[ext.to_sym]
    raise ArgumentError, "file #{filename} has an unsupported extension #{ext}" unless compressor_h
    if compressor_h
      begin
        self.minifier = compressor_h[:class].new(**compressor_h[:options])
      rescue Exception => e
        raise NoMinifierForThisType, "file #{source} has an unsupported extension #{ext}: #{e.inspect}"
      end
    end
  end

  def minify!(existing: :abort, replace: false)
    return false unless self.minifier
    raise ArgumentError, "File #{target} already exist!" if File.exist?(target) && existing == :abort
    File.open(target, 'w') do |file|
      file.write(minify) > 0
    end
    if replace
      FileUtils.move(target, source)
    end
  end

  def minify
    return nil unless minifier
    minifier.compress(File.read(source))
  end
end


