require 'net/http'
require 'nokogiri'
require 'm3u8'

class DAI
  def self.fetch_master(asset_key, ogncluster = nil)
    puts "Fetching master for asset key '#{asset_key}'"
    puts "Using ogncluster: '#{ogncluster}'" if ogncluster
    query_string = "?cust_params=ogncluster%3D#{ogncluster}" if ogncluster
    url = "https://dai.google.com/linear/hls/event/#{asset_key}/master.m3u8#{query_string}"
    res = Net::HTTP.get_response(URI(url))

    raise "Asset key '#{asset_key}' not found!" if res.code != "302"

    parsed_data = Nokogiri::HTML.parse(res.body)
    url = parsed_data.xpath("//a").first.values[0]
    puts "Found segmented manifest: #{url}"

    url
  end

  def self.fetch_variant(master_url, bitrate)
    res = Net::HTTP.get_response(URI(master_url))

    raise "Failed to fetch master playlist" if res.code != "200"

    master = M3u8::Playlist.read(res.body)
    variants = master.items.select do |i|
      (i.class == M3u8::PlaylistItem) && (i.bandwidth == bitrate.to_i)
    end
    variant = variants.first

    raise "Variant '#{bitrate}' not found" unless variant

    variant
  end

  def self.parse_dai_segments(manifest)
    res = Net::HTTP.get(URI(manifest))
    content = res.split("\n")
    all_segments = content.filter { |l| l.end_with?(".ts") }
    filter_dai_segments_range(all_segments)
  end

  private

  def self.filter_dai_segments_range(segments, offset = 2)
    first = last = -1

    segments.each_with_index do |s, i|
      if first_break?(s, first)
        first = i
      elsif last_break?(s, first)
        last = i - 1
        break
      end
    end

    raise "DAI not found" if last == -1

    first = first > offset.to_i ? first - offset.to_i : first
    last = last + offset.to_i < segments.count - 1 ? last + offset.to_i : last

    segments[first..last]
  end

  def self.first_break?(segment, first)
    google_domain(segment) && first == -1
  end

  def self.last_break?(segment, first)
    !google_domain(segment) && first != -1
  end

  def self.google_domain(name)
    name.start_with? "https://dai.google.com"
  end
end
