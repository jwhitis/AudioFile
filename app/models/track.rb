require "taglib"

class Track
  attr_accessor :filepath
  attr_accessor :metadata

  PROPERTIES = [
    :title,
    :artist,
    :album,
    :year,
    :track,
    :genre,
    :comment
  ]

  def initialize filepath
    @filepath = filepath
  end

  def read_tag
    metadata = {}
    TagLib::FileRef.open(filepath) do |fileref|
      if fileref.null?
        raise ArgumentError, "'#{File.basename(filepath)}' cannot be opened."
      else
        tag = fileref.tag
        PROPERTIES.each do |property|
          unless tag.send(property).nil?
            metadata[property] = tag.send(property)
          end
        end
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
      if fileref.null?
        raise ArgumentError, "'#{File.basename(filepath)}' cannot be opened."
      else
        tag = fileref.tag
        PROPERTIES.each do |property|
          unless metadata[property].nil?
            tag.send("#{property}=", metadata[property])
          end
        end
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
    title_from_filepath if metadata[:title].nil?
    get_metadata(api)
    write_tag
    rename
  end

end