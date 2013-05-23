require "test_helper"

class CollectionUnitTest < Test::Unit::TestCase

  def test_d1_stores_directory
    collection = Collection.new("test_dir")
    assert_equal("test_dir", collection.directory)
  end

  def test_d2_entry_list_returns_a_list_of_directory_entries
    collection = Collection.new("test_dir")
    entries = collection.entry_list("test_dir")
    assert_equal(["file1.txt", "level_two"], entries)
  end

  def test_d3_flatten_moves_all_files_to_root_and_removes_subdirectories
    collection = Collection.new("test_dir")
    collection.flatten
    assert_equal(["file1.txt", "file2.txt", "file3.txt"], collection.entry_list("test_dir"))
    `mkdir -p test_dir/level_two/level_three`
    `mv test_dir/file2.txt test_dir/level_two`
    `mv test_dir/file3.txt test_dir/level_two/level_three`
  end

  def test_d4_create_path_creates_new_artist_and_album_folders
    collection = Collection.new("test_dir2")
    metadata = {:artist => "AFI", :album => "Sing The Sorrow"}
    collection.create_path(metadata)
    assert(Dir.exist?("test_dir2/AFI/Sing The Sorrow"))
    `rm -r test_dir2/AFI`
  end

  def test_d5_create_path_adds_album_folders_to_existing_artist_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "The Downward Spiral"}
    collection.create_path(metadata)
    assert(Dir.exist?("test_dir2/Nine Inch Nails/The Downward Spiral"))
    `rm -r test_dir2/"Nine Inch Nails"/"The Downward Spiral"`
  end

  def test_d6_create_path_does_not_duplicate_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails/Year Zero"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "Year Zero"}
    collection.create_path(metadata)
    entries = collection.entry_list("test_dir2/Nine Inch Nails")
    assert_equal(["Year Zero"], entries)
  end

  def test_d7_move_track_moves_track_into_album_folder
    collection = Collection.new("test_dir2")
    new_path = "test_dir2/Nine Inch Nails/Year Zero"
    collection.move_track("test_dir2/07 Capital G.mp3", new_path)
    assert(File.exist?("test_dir2/Nine Inch Nails/Year Zero/07 Capital G.mp3"))
    `mv test_dir2/"Nine Inch Nails"/"Year Zero"/"07 Capital G.mp3" test_dir2`
  end

  # Add test for organize method.

end