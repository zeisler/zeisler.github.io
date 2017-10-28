require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ostruct'
require "rss"
require 'net/http'

def rss(lecture, path)
  xml = RSS::Maker.make("2.0") do |maker|
    maker.channel.language     = "en"
    maker.channel.author       = "Steve Gregg"
    maker.channel.updated      = Time.now.to_s
    maker.channel.link         = "http://www.thenarrowpath.com"
    maker.channel.title        = lecture.title
    maker.channel.description  = lecture.description
    maker.channel.itunes_image = "http://dustinzeisler.com/steve_gregg/steve_gregg.jpg"
    lecture.lectures.reverse.each.with_index do |audio, index|
      maker.items.new_item do |item|
        item.guid.content      = audio.link
        item.description       = audio.description
        item.link              = audio.link
        item.title             = audio.title
        item.enclosure.url     = audio.link
        item.enclosure.type    = "audio/mpeg"
        item.enclosure.length  = audio.length
        day_in_seconds         = 60*60*24
        index_days_seconds     = ((index + 1)*day_in_seconds)
        sixty_days_ago_seconds = (60*day_in_seconds)
        item.updated           = Time.now + index_days_seconds - sixty_days_ago_seconds
      end
    end

  end
  begin
    File.open("#{path}/" + lecture.title.downcase.gsub(' ', '_').gsub("’", "") + '.xml', 'w') { |file| file.write(xml.to_s) }
    puts xml
  rescue Errno::ENOENT => e
    puts e
  end
end

def public_link(lecture)
  "./#{lecture.title.downcase.gsub(' ', '_').gsub("’", "")}.xml"
end

def scrap(section)
  table_headers    = section.css('.audio_header,.audio_year').map { |a| a.children.first.to_s }
  section_title    = section.css('.blue_box').text.sub('New!', '').gsub("  ", " ")
  section_title    = section_title.empty? ? table_headers.first : section_title
  table_index      = 0
  base_description = "Lecture by Steve Gregg on #{section_title}"
  section.css('table').flat_map do |table|
    table_header = table_headers[table_index]
    table_index  += 1
    lecture_html = table.css('td a')
    table_title  = [section_title, table_header].compact.uniq.join(" - ")
    puts "scrapping #{table_title}"
    description    = lambda { |num| "#{table_title} (#{num} of #{lecture_html.count})" }
    table_lectures = lecture_html.map.with_index do |lecture, index|
      link   = if lecture['href'].include?("http://")
                 lecture['href']
               else
                 "http://www.thenarrowpath.com/" + lecture['href']
               end
      uri    = URI.parse(URI.encode(link))
      length = 0
      begin
        Net::HTTP.start(uri.host, uri.port) do |http|
          response = http.request_head(link)
          length   = response['content-length']
        end
      rescue => e
        puts uri
        puts e
      end
      next if link.include?("#")
      OpenStruct.new(length: length, link: link, title: lecture.text, description: description.call(index+1))
    end.to_a.compact

    OpenStruct.new(title: table_title, lectures: table_lectures, description: base_description)
  end
end

[%w(verse_by_verse verse_by_verse), %w(topical_lectures topical)].each do |url, path|
  puts url
  page     = Nokogiri::HTML(open("http://www.thenarrowpath.com/#{url}.php"))
  lectures = page.css('.content')[1..-1].flat_map do |section|
    scrap(section)
  end

  file = File.open(path + '/index.html', 'w')
  file.puts '<!DOCTYPE html><html><head></head><body><ul>'
  lectures.map do |l|
    rss(l, path)
    file.puts "<li><a href=' #{public_link(l)}'>#{l.title}</a></li>"
  end
  file.puts '</ul></body></html>'

  file.close
end
