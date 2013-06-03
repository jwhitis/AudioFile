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
    TagLib::FileRef.open(filepath) do |fileref|
      if fileref.null?
        "'#{File.basename(filepath)}' cannot be opened."
      else
        tag = fileref.tag
        metadata = {}
        PROPERTIES.each do |property|
          unless tag.send(property).nil?
            metadata[property] = tag.send(property)
          end
        end
        title_from_filepath if metadata[:title].nil?
        @metadata = metadata
      end
    end
  end

  def title_from_filepath
    title = File.basename(filepath, ".*")
    title = title.scan(/[^_\s]+/).join(" ")
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
    if new_data.is_a?(String)
      "#{new_data} '#{File.basename(filepath)}' was skipped."
    else
      @metadata = new_data
    end
  end

  def write_tag
    TagLib::FileRef.open(filepath) do |fileref|
      if fileref.null?
        "'#{File.basename(filepath)}' cannot be opened."
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
    nil
  end

  def update api
    sequence = [:read_tag, :get_metadata, :write_tag, :rename]
    sequence.each do |step|
      message = step == :get_metadata ? send(step, api) : send(step)
      return message if message.is_a?(String)
    end
  end

end