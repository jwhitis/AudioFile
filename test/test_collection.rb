require "test/unit"
require "./lib/collection.rb"

class CollectionUnitTest < Test::Unit::TestCase

  def test_d1_stores_directory
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir")
    assert_equal("/Users/jwhitis/Desktop/AudioFile/test_dir", collection.directory)
  end

  def test_d2_entry_list_returns_a_list_of_directory_entries
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir")
    entries = collection.entry_list("test_dir")
    assert_equal(["file1.txt", "level_two"], entries)
  end

  def test_d3_flatten_dir_moves_all_files_to_root_and_removes_subdirectories
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir")
    collection.flatten_dir("test_dir")
    assert_equal(["file1.txt", "file2.txt", "file3.txt"], collection.entry_list("test_dir"))
    `mkdir -p test_dir/level_two/level_three`
    `mv test_dir/file2.txt test_dir/level_two/file2.txt`
    `mv test_dir/file3.txt test_dir/level_two/level_three/file3.txt`
  end

end