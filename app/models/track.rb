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

  def update api
    steps = [:read_tag, :title_from_filepath, :get_metadata, :write_tag, :rename]
    steps.each do |step|
      step == :get_metadata ? send(step, api) : send(step)
      break if metadata.has_key?(:error)
    end
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
        process_tag(fileref, action)
      end
    end
  end

  def process_tag fileref, action
    tag = fileref.tag
    if action == :read
      @metadata = get_properties(tag)
    elsif action == :write
      set_properties(tag, fileref)
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
    File.rename(filepath, filepath_from_metadata)
    @filepath = filepath_from_metadata
  end

  def filepath_from_metadata
    track = "%02d" % metadata[:track].to_s
    title = metadata[:title]
    directory = File.dirname(filepath)
    extension = File.extname(filepath)
    "#{directory}/#{track} #{title}#{extension}"
  end

end