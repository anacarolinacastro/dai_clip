class FFMPEG
  def self.generate_clip_command(segments, heigth, width, fps, output_filename = "output.mp4")
    output_filename = "output.mp4"
    command = "ffmpeg "
    segments.each { |s| command << "-i \"#{s}\" \\\n" }
    command << "-filter_complex \\\n \""
    segments.each_with_index do |_, i|
      command << "[#{i}:v]scale=#{width}:#{heigth}:force_original_aspect_ratio=decrease,pad=#{width}:#{heigth}:-1:-1,setsar=1,fps=#{fps},format=yuv420p[v#{i}];\n"
    end
    segments.each_with_index { |_, i| command << "[v#{i}][#{i}:a]" }
    command << "concat=n=#{segments.count}:v=1:a=1[v][a]\" "
    command << "-map \"[v]\" -map \"[a]\" -c:v libx264 -c:a aac -movflags +faststart #{output_filename}"
    command
  end
end
