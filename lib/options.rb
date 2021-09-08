require "optparse"

class Options
  attr_accessor :options

  AVAILABLE = [
    {name: :bitrate, short: "-bBITRATE", long: "--bitrate=BITRATE", description: "Chooses the variant bitrate"}, # should be required
    {name: :asset_key, short: "-aASSET_KEY", long: "--asset_key=ASSET_KEY", description: "Asset key to fetch DAI manifest"}, # should be required
    {name: :domain, short: "-oDOMAIN", long: "--domain=DOMAIN", description: "Domain used to download segments"},
    {name: :ogncluster, short: "-oOGNCLUSTER", long: "--ogncluster=OGNCLUSTER", description: "User cluster param for segmented AD"},
    {name: :offset, short: "-OOFFSET", long: "--offset=OFFSET", description: "The number of segments of the stream to use before and after the AD"},
    {name: :output_name, short: "-nNAME", long: "--output_name=NAME", description: "The name for the output file"},
    {name: :override, short: "-y", long: "--override", description: "Override output file"}
  ]

  def initialize
    parse_options
  end

  def parse_options
    @options = {}
    OptionParser.new do |opts|
      AVAILABLE.each do |option|
        opts.on(option[:short], option[:long], option[:description]) do |o|
          @options[option[:name]] = o
        end
      end
    end.parse!
  end
end
