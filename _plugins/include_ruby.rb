module Jekyll
  class IncludeRuby < Liquid::Tag

    def render(context)
      file_path   = File.join(context.registers[:site].source, "_includes", "ruby_code", @markup.gsub(" ", ""))
      ruby_source = File.open(file_path).read
      ruby_source = liquid_in_comments(ruby_source)
      ruby_source = highlighting(ruby_source)
      Liquid::Template.parse(ruby_source).render(context)
    end

    def liquid_in_comments(ruby)
      ruby.gsub('#{%', "{%")
    end

    def highlighting(ruby)
      <<-TEXT
{% highlight ruby %}
#{ruby}
{% endhighlight %}
      TEXT
    end
  end
end

Liquid::Template.register_tag('ruby', Jekyll::IncludeRuby)
