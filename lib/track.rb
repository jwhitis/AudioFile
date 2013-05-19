require "taglib"

class Track
attr_accessor :filename

  def initialize filename
    @filename = filename
  end

  def read_tag filename
    metadata = Hash.new
    TagLib::FileRef.open(filename) do |fileref|
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

  def write_tag filename, metadata
    TagLib::FileRef.open(filename) do |fileref|
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

  def rename current_filename, metadata
    track = "%02d" % metadata[:track].to_s
    title = metadata[:title]
    extension = File.extname(current_filename)
    new_filename = "#{track} #{title}#{extension}"
    File.rename(current_filename, new_filename)
    @filename = new_filename
  end

end # Track class