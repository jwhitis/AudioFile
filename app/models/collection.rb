require "fileutils"

class Collection
  include Colorize
  attr_reader :directory

  def initialize directory
    directory = directory.gsub(/["']/, "")
    @directory = if Dir.exist?(directory)
                   directory
                 else
                   {:error => "'#{directory}' is not a valid directory."}
                 end
  end

  def organize api
    flatten
    entries = entry_list(directory)
    entries.each { |entry| process_entry(entry, api) }
  end

  def flatten
    begin
      flat = true
      entry_list(directory).each do |entry|
        entry_path = "#{directory}/#{entry}"
        if Dir.exist?(entry_path)
          move_contents_to_root(entry_path)
          FileUtils.remove_dir(entry_path)
          flat = false
        end
      end
    end until flat
  end

  def entry_list path
    entries = Dir.entries(path)
    entries.select { |entry| !entry.start_with?(".") }
  end

  def move_contents_to_root entry_path
    entry_list(entry_path).each do |nested_entry|
      current_path = "#{entry_path}/#{nested_entry}"
      new_path = "#{directory}/#{nested_entry}"
      move_entry(current_path, new_path)
    end
  end

  def move_entry current_path, new_path
    new_path = unique_name(new_path)
    FileUtils.move(current_path, new_path)
  end

  def unique_name filepath
    title = File.basename(filepath, ".*")
    dirname = File.dirname(filepath)
    extension = File.extname(filepath)
    number = 1
    while File.exist?(filepath)
      filepath = "#{dirname}/#{title}-#{number}#{extension}"
      number += 1
    end
    filepath
  end

  def process_entry entry, api
    track = Track.new("#{directory}/#{entry}")
    track.update(api)
    print_error(track) and return if track.metadata.has_key?(:error)
    new_path = create_filepath(track)
    move_entry(track.filepath, new_path)
    track.filepath = new_path
  end

  def print_error track
    puts track.metadata[:error].colorize(RED)
    puts "Still working...".colorize(CYAN)
  end

  def create_filepath track
    dirname = create_dir(track.metadata)
    "#{dirname}/#{File.basename(track.filepath)}"
  end

  def create_dir metadata
    path = "#{directory}/#{metadata[:artist]}/#{metadata[:album]}"
    FileUtils.mkpath(path)
    path
  end

end