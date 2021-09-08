require 'net/http'
require 'nokogiri'
require 'm3u8'
require 'json'

class DAI
  def self.fetch_master(asset_key, ogncluster = nil)
    puts "Fetching master for asset key '#{asset_key}'"
    # puts "Using ogncluster: '#{ogncluster}'" if ogncluster

    url = "https://dai.google.com/linear/v1/hls/event/#{asset_key}/stream"
    res = Net::HTTP.post_form(URI(url), {})

    raise "Asset key '#{asset_key}' not found!" if res.code != "201"
    JSON.parse(res.body)['stream_manifest']
  end

  def self.fetch_variant(master_url, bitrate)
    master_url = "https://dai.google.com#{master_url.split("=").last}"
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

  def self.parse_dai_segments(manifest, domain)
    manifest = "https://dai.google.com#{manifest}"
    res = Net::HTTP.get(URI(manifest))
    content = res.split("\n")
    all_segments = content.select { |l| l.end_with?(".ts") }
    filter_dai_segments_range(all_segments).collect {|s| replace_domain(s, domain)}
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

    raise "DAI break found but still airing" if (first > 0 && last == -1)
    raise "DAI break not found" if last == -1

    first = first > offset.to_i ? first - offset.to_i : first
    last = last + offset.to_i < segments.count - 1 ? last + offset.to_i : last

    segments[first..last]
  end

  def self.replace_domain(segment, domain)
    return segment if google_domain(segment)
    "#{domain}#{segment}"
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
