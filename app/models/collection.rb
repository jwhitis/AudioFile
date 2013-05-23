require "fileutils"

class Collection
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
        if Dir.exist?("#{directory}/#{entry}")
          nested_entries = entry_list("#{directory}/#{entry}")
          nested_entries.each do |nested_entry|
            FileUtils.move("#{directory}/#{entry}/#{nested_entry}", directory)
          end
          FileUtils.remove_dir("#{directory}/#{entry}")
          flat = false
        end
      end
    end until flat
  end

  def create_path metadata
    path = "#{directory}/#{metadata[:artist]}/#{metadata[:album]}"
    FileUtils.mkpath(path) unless Dir.exist?(path)
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
        raise ArgumentError, error.message
        next
      end
      new_path = create_path(track.metadata)
      filepath = move_track(track.filepath, new_path)
      track.filepath = filepath
    end
  end

end