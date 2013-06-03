require "fileutils"

class Collection
  include Colorize
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
      entry_list(directory).each do |entry|
        entry_path = "#{directory}/#{entry}"
        if Dir.exist?(entry_path)
          entry_list(entry_path).each do |nested_entry|
            current_path = "#{entry_path}/#{nested_entry}"
            new_path = unique_name("#{directory}/#{nested_entry}")
            FileUtils.move(current_path, new_path)
          end
          FileUtils.remove_dir(entry_path)
          flat = false
        end
      end
    end until flat
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

  def create_path metadata
    path = "#{directory}/#{metadata[:artist]}/#{metadata[:album]}"
    FileUtils.mkpath(path)
    path
  end

  def move_track current_path, new_path
    new_path = unique_name("#{new_path}/#{File.basename(current_path)}")
    FileUtils.move(current_path, new_path)
    new_path
  end

  def organize api
    flatten
    entries = entry_list(directory)
    entries.each do |entry|
      track = Track.new("#{directory}/#{entry}")
      message = track.update(api)
      if message.is_a?(String)
        puts message.colorize(RED)
        puts "Still working...".colorize(CYAN)
        next
      end
      new_path = create_path(track.metadata)
      filepath = move_track(track.filepath, new_path)
      track.filepath = filepath
    end
  end

end