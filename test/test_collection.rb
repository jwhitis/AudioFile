require "test_helper"

class CollectionUnitTest < Test::Unit::TestCase

  def test_01_stores_directory
    collection = Collection.new("test_dir")
    assert_equal("test_dir", collection.directory)
  end

  def test_02_stores_error_message_if_directory_is_invalid
    collection = Collection.new("does_not_exist")
    expected = {:error => "'does_not_exist' is not a valid directory."}
    assert_equal(expected, collection.directory)
  end

  def test_03_organize_removes_current_file_structure
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    collection = Collection.new("test_dir3")
    collection.organize(api)
    assert(!Dir.exist?("Michael Jackson"))
    collection.flatten
    `mkdir -p test_dir3/"Michael Jackson"/Thriller`
    `mkdir test_dir3/"Sunny Day Real Estate"`
    `mv test_dir3/"03 The Future Freaks Me Out.mp3" test_dir3/"Michael Jackson"/Thriller`
    `mv test_dir3/"01 Seven.mp3" test_dir3/"Sunny Day Real Estate"`
  end

  def test_04_organize_creates_new_artist_and_album_folders
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    collection = Collection.new("test_dir3")
    collection.organize(api)
    entries = collection.entry_list("test_dir3")
    assert(["Motion City Soundtrack", "Sunny Day Real Estate", "The English Beat"].all? { |file| entries.include?(file) })
    collection.flatten
    `mkdir -p test_dir3/"Michael Jackson"/Thriller`
    `mkdir test_dir3/"Sunny Day Real Estate"`
    `mv test_dir3/"03 The Future Freaks Me Out.mp3" test_dir3/"Michael Jackson"/Thriller`
    `mv test_dir3/"01 Seven.mp3" test_dir3/"Sunny Day Real Estate"`
  end

  def test_05_organize_renames_tracks_and_moves_them_into_album_folders
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    collection = Collection.new("test_dir3")
    collection.organize(api)
    assert(File.exist?("test_dir3/Sunny Day Real Estate/Diary/01 Seven.mp3"))
    collection.flatten
    `mkdir -p test_dir3/"Michael Jackson"/Thriller`
    `mkdir test_dir3/"Sunny Day Real Estate"`
    `mv test_dir3/"03 The Future Freaks Me Out.mp3" test_dir3/"Michael Jackson"/Thriller`
    `mv test_dir3/"01 Seven.mp3" test_dir3/"Sunny Day Real Estate"`
  end

  def test_06_flatten_moves_all_files_to_collection_root
    collection = Collection.new("test_dir")
    collection.flatten
    entries = collection.entry_list("test_dir")
    assert(["file1.txt", "file2.txt", "file3.txt"].all? { |file| entries.include?(file) })
    `mkdir -p test_dir/level_two/level_three`
    `mv test_dir/file2.txt test_dir/level_two`
    `mv test_dir/file3.txt test_dir/level_two/level_three`
  end

  def test_07_flatten_removes_subdirectories
    collection = Collection.new("test_dir")
    collection.flatten
    entries = collection.entry_list("test_dir")
    assert(["level_two", "level_three"].all? { |file| !File.exist?(file) })
    `mkdir -p test_dir/level_two/level_three`
    `mv test_dir/file2.txt test_dir/level_two`
    `mv test_dir/file3.txt test_dir/level_two/level_three`
  end

  def test_08_entry_list_returns_a_list_of_directory_entries
    collection = Collection.new("test_dir")
    entries = collection.entry_list("test_dir")
    assert(["file1.txt", "level_two"].all? { |file| entries.include?(file) })
  end

  def test_09_move_contents_to_root_moves_nested_entries_to_collection_root
    collection = Collection.new("test_dir")
    collection.move_contents_to_root("test_dir/level_two")
    entries = collection.entry_list("test_dir")
    expected = ["file1.txt", "file2.txt", "level_two", "level_three"]
    assert(expected.all? { |file| entries.include?(file) })
    `mv test_dir/file2.txt test_dir/level_two`
    `mv test_dir/level_three test_dir/level_two`
  end

  def test_10_move_entry_moves_track_into_album_folder
    collection = Collection.new("test_dir2")
    new_path = "test_dir2/Nine Inch Nails/Year Zero/07 Capital G.mp3"
    collection.move_entry("test_dir2/07 Capital G.mp3", new_path)
    assert(File.exist?("test_dir2/Nine Inch Nails/Year Zero/07 Capital G.mp3"))
    `mv test_dir2/"Nine Inch Nails"/"Year Zero"/"07 Capital G.mp3" test_dir2`
  end

  def test_11_move_entry_creates_unique_filepath_for_duplicate_tracks
    collection = Collection.new("test_dir2")
    new_path = "test_dir2/Nine Inch Nails/Year Zero/05 Vessel.mp3"
    collection.move_entry("test_dir2/05 Vessel.mp3", new_path)
    entries = collection.entry_list("test_dir2/Nine Inch Nails/Year Zero")
    assert(["05 Vessel-1.mp3", "05 Vessel.mp3"].all? { |file| entries.include?(file) })
    `mv test_dir2/"Nine Inch Nails"/"Year Zero"/"05 Vessel-1.mp3" test_dir2/"05 Vessel.mp3"`
  end

  def test_12_process_track_updates_metadata_and_moves_track_into_folder
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    collection = Collection.new("test_dir3")
    collection.process_entry("13 Too Nice To Talk To.mp3", api)
    assert(File.exist?("test_dir3/The English Beat/Beat This! - The Best Of The Beat/13 Too Nice To Talk To.mp3"))
    `mv test_dir3/"The English Beat"/"Beat This! - The Best Of The Beat"/"13 Too Nice To Talk To.mp3" test_dir3`
  end

  def test_13_unique_name_returns_unique_filepath
    collection = Collection.new("test_dir2")
    new_filepath = collection.unique_name("test_dir2/07 Capital G.mp3")
    assert_equal("test_dir2/07 Capital G-1.mp3", new_filepath)
  end

  def test_14_create_filepath_returns_new_track_filepath
    collection = Collection.new("test_dir2")
    track = Track.new("02 Little Secrets.mp3")
    track.metadata = {
      :artist => "Passion Pit",
      :album => "Manners",
      :title => "Little Secrets"
    }
    expected = "test_dir2/Passion Pit/Manners/02 Little Secrets.mp3"
    assert_equal(expected, collection.create_filepath(track))
    `rm -r test_dir2/"Passion Pit"`
  end

  def test_15_create_dir_creates_new_artist_and_album_folders
    collection = Collection.new("test_dir2")
    metadata = {:artist => "AFI", :album => "Sing The Sorrow"}
    collection.create_dir(metadata)
    assert(Dir.exist?("test_dir2/AFI/Sing The Sorrow"))
    `rm -r test_dir2/AFI`
  end

  def test_16_create_dir_adds_album_folders_to_existing_artist_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "The Downward Spiral"}
    collection.create_dir(metadata)
    assert(Dir.exist?("test_dir2/Nine Inch Nails/The Downward Spiral"))
    `rm -r test_dir2/"Nine Inch Nails"/"The Downward Spiral"`
  end

  def test_17_create_dir_does_not_duplicate_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails/Year Zero"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "Year Zero"}
    collection.create_dir(metadata)
    assert_equal(["Year Zero"], collection.entry_list("test_dir2/Nine Inch Nails"))
  end

end