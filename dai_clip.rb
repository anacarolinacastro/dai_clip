require './lib/options'
require './lib/dai'
require './lib/ffmpeg'

class DAIClip
  def self.exec(opts)
    begin
      master_url = DAI.fetch_master(opts[:asset_key], opts[:ogncluster])
      variant = DAI.fetch_variant(master_url, opts[:bitrate])
      segments = DAI.parse_dai_segments(variant.uri, opts[:domain])

      raise 'Segments not found' if segments.empty?


      filename = "#{opts[:asset_key]}_#{opts[:bitrate]}_#{Time.now.strftime("%Y-%m-%d_%Hh%Mm%Ss")}.ts"
      puts FFMPEG.generate_clip_command(segments, variant.height, variant.width, variant.frame_rate, filename)
    rescue Exception => e
      puts "Error fetching clip: #{e}"
    end
  end
end

opts = Options.new
DAIClip.exec(opts.options)
