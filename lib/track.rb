require "taglib"

class Track
  attr_reader :filepath

  def initialize filepath
    @filepath = filepath
  end

  def read_tag filepath
    metadata = Hash.new
    TagLib::FileRef.open(filepath) do |fileref|
      unless fileref.null?
        tag = fileref.tag
        metadata[:title] = tag.title
        metadata[:artist] = tag.artist
        metadata[:album] = tag.album
        metadata[:year] = tag.year
        metadata[:track] = tag.track
        metadata[:genre] = tag.genre
        metadata[:comment] = tag.comment
      end
    end
    metadata
  end

  def write_tag filepath, metadata
    TagLib::FileRef.open(filepath) do |fileref|
      unless fileref.null?
        tag = fileref.tag
        tag.title = metadata[:title]
        tag.artist = metadata[:artist]
        tag.album = metadata[:album]
        tag.year = metadata[:year].to_i
        tag.track = metadata[:track].to_i
        tag.genre = metadata[:genre]
        tag.comment = metadata[:comment]
        fileref.save
      end
    end
  end

  def rename current_filepath, metadata
    track = "%02d" % metadata[:track].to_s
    title = metadata[:title]
    directory = File.dirname(current_filepath)
    extension = File.extname(current_filepath)
    new_filepath = "#{directory}/#{track} #{title}#{extension}"
    File.rename(current_filepath, new_filepath)
    @filepath = new_filepath
  end

end # Track class