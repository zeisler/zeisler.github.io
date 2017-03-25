require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ostruct'

class ScrapToRss

  attr_reader :url,
              :page_name,
              :collection_selector,
              :title_selector,
              :file_link,
              :base_description,
              :file_description,
              :file_path.
              :collections

  def initialize( url:                  url,
                  page_name:            page_name,
                  collection_selector:  collection_selector,
                  title_selector:       title_selector
                  file_link:            file_link,
                  base_description:     base_description,
                  file_description:     file_description
                  file_path:            file_path )
    @url                 = url
    @page_name           = page_name
    @collection_selector = collection_selector
    @title_selector      = title_selector
    @file_link           = file_link
    @base_description    = base_description
    @file_description    = file_description
    @file_path           = file_path

    @collections = scrap_page
    create_rss
  end

  private

  def scrape_page
    require 'nokogiri'
    Nokogiri::HTML(open(url))
    lectures = page.css(collection_selector)[4..-1].map do |section|
      lectures = section.css(file_link)
      title = section.css(title_selector).text.sub('New!', '')
      base_description = "#{base_description} on #{title}"
      description = lambda{ |num| "#{base_description}(#{num} of #{lectures.count})"}
      lectures = lectures.each_with_index.map do |lecture, index|
        OpenStruct.new( { link: lecture['href'], title: lecture.text, description: description.call(index+1) } )
      end
      OpenStruct.new( {title: title, lectures: lectures, description: base_description} )
    end
  end

  def create_rss

  end

end

ScrapToRss.new( url: "http://www.thenarrowpath.com/verse_by_verse.php",
                  page_name: 'verse_by_verse',
                  collection_selector: '.content',
                  title_selector: '.audio_header',
                  file_link: 'td a',
                  base_description: 'Lecture by Steve Gregg',
                  file_path: './')

page = Nokogiri::HTML(open("http://www.thenarrowpath.com/verse_by_verse.php"))
lectures = page.css('.content')[4..-1].map do |section|
  lectures = section.css('td a')
  title = section.css('.audio_header').text.sub('New!', '')
  base_description = "Lecture by Steve Greegs on #{title}"
  description = lambda{ |num| "#{base_description}(#{num} of #{lectures.count})"}
  lectures = lectures.each_with_index.map do |lecture, index|
    OpenStruct.new( { link: lecture['href'], title: lecture.text, description: description.call(index+1) } )
  end
  OpenStruct.new( {title: title, lectures: lectures, description: base_description} )
end

require "rss"

def rss(lecture)
  xml = RSS::Maker.make("2.0") do |maker|
    maker.channel.language = "en"
    maker.channel.author = "Steve Gregg"
    maker.channel.updated = Time.now.to_s
    maker.channel.link = "http://www.thenarrowpath.com"
    maker.channel.title = lecture.title
    maker.channel.description = lecture.description
    maker.channel.itunes_image = "steve_gregg.jpg"
    lecture.lectures.each do |audio|
      maker.items.new_item do |item|
          item.description = audio.description
          item.link = audio.link
          item.title = audio.title
          item.updated = Time.now.to_s
          item.enclosure.url = audio.link
          item.enclosure.type = "audio/mpeg"
          item.enclosure.length = 0
        end
      end

  end
  File.open(lecture.title.downcase.gsub(' ', '_') + '.xml', 'w') { |file| file.write(xml.to_s) }
  puts xml
end

def public_link(lecture)
  "./#{lecture.title.downcase.gsub(' ', '_')}.xml"
end

file = File.open('verse_by_verse.html', 'w')
file.puts '<!DOCTYPE html><html><head></head><body><ul>'
lectures.map do |l|
  rss(l)
  file.puts "<li><a href=' #{public_link(l)}'>#{l.title}</a></li>"
end
file.puts '</ul></body></html>'

file.close