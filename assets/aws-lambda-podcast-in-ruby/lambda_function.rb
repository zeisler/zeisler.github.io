require "json"
require "aws-sdk-s3"
require "rss"
require "yaml"

def lambda_handler(event:, context:)
  xml = build_feed
  s3_client.put_object({
                         acl:          "public-read",
                         bucket:       secrets["s3"]["bucket"],
                         key:          "feed.xml",
                         content_type: "application/rss+xml",
                         body:         xml.to_s
                       })

  {
    status: 200,
    body:   xml
  }
end

def build_feed
  RSS::Maker.make("2.0") do |maker|
    maker.channel.language    = "en"
    maker.channel.author      = "Dustin Zeisler"
    maker.channel.updated     = Time.now.to_s
    maker.channel.link        = "http://www.example.com"
    maker.channel.title       = "Classical Music"
    maker.channel.description = "Classical Music Podcast"
    # maker.channel.itunes_image = ""
    # maker.image.url            = ""
    episodes.each do |id, meta|
      maker.items.new_item do |item|
        item.guid.content     = id
        item.title            = meta[:title]
        item.description      = meta[:description]
        item.link             = meta[:audio].public_url
        item.enclosure.url    = meta[:audio].public_url
        item.enclosure.type   = "audio/mpeg"
        item.enclosure.length = meta[:audio].content_length
        item.updated          = meta[:published]
      end
    end
  end
end

def episodes
  bucket   = s3_resource.bucket(secrets["s3"]["bucket"])
  episodes = {}
  bucket.objects.each do |item|
    _root_dir, episode_num, file = item.key.split("/")
    if file == "metadata.json"
      episodes[episode_num]       ||= {}
      meta = JSON.parse(item.get.body.read, symbolize_names: true)
      episodes[episode_num].merge!(meta)
    elsif file == "audio.mp3"
      episodes[episode_num]       ||= {}
      episodes[episode_num][:audio] = item
    end
  end
  puts episodes
  episodes
end

def s3_resource
  @s3_resource ||= Aws::S3::Resource.new(
    region:            secrets["s3"]["region"],
    access_key_id:     secrets["s3"]["access_key_id"],
    secret_access_key: secrets["s3"]["secret_access_key"]
  )
end

def s3_client
  @s3_client ||= Aws::S3::Client.new(
    region:            secrets["s3"]["region"],
    access_key_id:     secrets["s3"]["access_key_id"],
    secret_access_key: secrets["s3"]["secret_access_key"]
  )
end

def secrets
  @secrets ||= YAML.load(File.read("secrets.yml"))
end
