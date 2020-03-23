module Jekyll
  module CustomExtensionsFilter
    def long_date(date)
      puts "Parsing date: #{date.inspect}"
      ([Date, Time].include?(date.class) ? date : Date.parse(date)).strftime("%A, %d %b %Y")
    end

    def gsub(string, regex, replacement)
      string.gsub(Regexp.new(regex), replacement)
    end
  end
end

Liquid::Template.register_filter(Jekyll::CustomExtensionsFilter)
