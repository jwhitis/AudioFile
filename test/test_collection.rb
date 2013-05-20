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

  def test_d4_create_folders_creates_new_artist_and_album_folders
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir2")
    metadata = {:artist => "AFI", :album => "Sing The Sorrow"}
    collection.create_folders("test_dir2", metadata)
    assert(Dir.exist?("test_dir2/AFI/Sing The Sorrow"))
    `rm -r test_dir2/AFI`
  end

  def test_d5_create_folders_adds_album_folders_to_existing_artist_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails"))
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "The Downward Spiral"}
    collection.create_folders("test_dir2", metadata)
    assert(Dir.exist?("test_dir2/Nine Inch Nails/The Downward Spiral"))
    `rm -r test_dir2/"Nine Inch Nails"/"The Downward Spiral"`
  end

  def test_d6_create_folders_does_not_duplicate_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails/Year Zero"))
    collection = Collection.new("/Users/jwhitis/Desktop/AudioFile/test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "Year Zero"}
    collection.create_folders("test_dir2", metadata)
    entries = collection.entry_list("test_dir2/Nine Inch Nails")
    assert_equal(["Year Zero"], entries)
  end

end