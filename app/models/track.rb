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
    open_tag(:read)
  end

  def write_tag
    open_tag(:write)
  end

  def open_tag action
    TagLib::FileRef.open(filepath) do |fileref|
      if fileref.null?
        @metadata = {:error => "'#{File.basename(filepath)}' cannot be opened."}
      else
        tag = fileref.tag
        if action == :read
          @metadata = get_properties(tag)
        elsif action == :write
          set_properties(tag, fileref)
        end
      end
    end
  end

  def get_properties tag
    metadata = {}
    PROPERTIES.each do |property|
      unless tag.send(property).nil?
        metadata[property] = tag.send(property)
      end
    end
    metadata
  end

  def set_properties tag, fileref
    PROPERTIES.each do |property|
      unless metadata[property].nil?
        tag.send("#{property}=", metadata[property])
      end
    end
    fileref.save
  end

  def title_from_filepath
    if metadata[:title].nil?
      title = File.basename(filepath, ".*")
      @metadata[:title] = title.scan(/[^_\s]+/).join(" ")
    end
  end

  def get_metadata api
    query = api.query(metadata)
    new_data = api.search(query)
    @metadata = new_data.is_a?(Hash) ? new_data : format_error(new_data)
  end

  def format_error message
    {:error => "#{message} '#{File.basename(filepath)}' was skipped."}
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
    steps = [:read_tag, :title_from_filepath, :get_metadata, :write_tag, :rename]
    steps.each do |step|
      if step == :get_metadata
        send(step, api)
      else
        send(step)
      end
      break unless metadata[:error].nil?
    end
  end

end