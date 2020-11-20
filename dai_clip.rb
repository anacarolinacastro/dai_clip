require './lib/options'
require './lib/dai'
require './lib/ffmpeg'

class DAIClip
  def self.exec(opts)
    begin
      master_url = DAI.fetch_master(opts[:asset_key], opts[:ogncluster])
      variant = DAI.fetch_variant(master_url, opts[:bitrate])
      segments = DAI.parse_dai_segments(variant.uri)

      raise 'Segments no found' if segments.empty?

      FFMPEG.join(segments, variant.height, variant.width, variant.frame_rate, opts[:output_name])
    rescue Exception => e
      puts "Error fetching clip: #{e}"
    end
  end
end

opts = Options.new
DAIClip.exec(opts.options)
