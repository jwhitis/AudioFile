require "fileutils"

class Collection
  attr_reader :directory

  def initialize directory
    @directory = directory
  end

  def entry_list directory
    entries = Dir.entries(directory)
    entries.select { |entry| !entry.start_with?(".") }
  end

  def flatten_dir directory
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

end # Collection class