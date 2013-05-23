require "taglib"

class Track
  attr_accessor :filepath
  attr_accessor :metadata

  def initialize filepath
    @filepath = filepath
  end

  def read_tag
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
    @metadata = metadata
  end

  def title_from_filepath
    title = File.basename(filepath, ".*")
    title = title.gsub(/[-_]/, " ")
    title = title.sub(/\A\d+/, "").strip
    if metadata.nil?
      @metadata = {:title => title}
    else
      @metadata[:title] = title
    end
    title
  end

  def get_metadata api
    query = api.query(metadata)
    new_data = api.search(query)
    @metadata = new_data
  end

  def write_tag
    TagLib::FileRef.open(filepath) do |fileref|
      unless fileref.null?
        tag = fileref.tag
        tag.title = metadata[:title] unless metadata[:title].nil?
        tag.artist = metadata[:artist] unless metadata[:artist].nil?
        tag.album = metadata[:album] unless metadata[:album].nil?
        tag.year = metadata[:year].to_i unless metadata[:year].nil?
        tag.track = metadata[:track].to_i unless metadata[:track].nil?
        tag.genre = metadata[:genre] unless metadata[:genre].nil?
        tag.comment = metadata[:comment] unless metadata[:comment].nil?
        fileref.save
      end
    end
  end

  def rename
    track = "%02d" % metadata[:track].to_s
    title = metadata[:title]
    directory = File.dirname(filepath)
    extension = File.extname(filepath)
    new_filepath = "#{directory}/#{track} #{title}#{extension}"
    File.rename(filepath, new_filepath)
    @filepath = new_filepath
  end

  def update api
    read_tag
    get_metadata(api)
    write_tag
    rename
  end

end