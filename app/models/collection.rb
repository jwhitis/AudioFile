require "fileutils"

class Collection
  include Formatter
  attr_reader :directory

  def initialize directory
    directory = directory.gsub(/["']/, "")
    if Dir.exist?(directory)
      @directory = directory
    else
      raise ArgumentError, "'#{directory}' is not a valid directory."
    end
  end

  def entry_list path
    entries = Dir.entries(path)
    entries.select { |entry| !entry.start_with?(".") }
  end

  def flatten
    begin
      flat = true
      entries = entry_list(directory)
      entries.each do |entry|
        entry_path = "#{directory}/#{entry}"
        if Dir.exist?(entry_path)
          nested_entries = entry_list(entry_path)
          nested_entries.each do |nested_entry|
            current_filepath = "#{entry_path}/#{nested_entry}"
            new_filepath = unique_name("#{directory}/#{nested_entry}")
            FileUtils.move(current_filepath, new_filepath)
          end
          FileUtils.remove_dir(entry_path)
          flat = false
        end
      end
    end until flat
  end

  def unique_name filepath
    title = File.basename(filepath, ".*")
    extension = File.extname(filepath)
    number = 1
    while File.exist?(filepath)
      filepath = "#{directory}/#{title}-#{number}#{extension}"
      number += 1
    end
    filepath
  end

  def create_path metadata
    path = "#{directory}/#{metadata[:artist]}/#{metadata[:album]}"
    FileUtils.mkpath(path)
    path
  end

  def move_track current_path, new_path
    FileUtils.move(current_path, new_path)
    "#{new_path}/#{File.basename(current_path)}"
  end

  def organize api
    flatten
    entries = entry_list(directory)
    entries.each do |entry|
      track = Track.new("#{directory}/#{entry}")
      begin
        track.update(api)
      rescue ArgumentError => error
        puts error.message.colorize(RED)
        puts "Still working...".colorize(CYAN)
        next
      end
      new_path = create_path(track.metadata)
      filepath = move_track(track.filepath, new_path)
      track.filepath = filepath
    end
  end

end