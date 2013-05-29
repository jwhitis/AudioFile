require "test_helper"

class CollectionUnitTest < Test::Unit::TestCase

  def test_01_stores_directory
    collection = Collection.new("test_dir")
    assert_equal("test_dir", collection.directory)
  end

  def test_02_raises_error_if_directory_is_invalid
    assert_raise(ArgumentError) do
      collection = Collection.new("does_not_exist")
    end
  end

  def test_03_entry_list_returns_a_list_of_directory_entries
    collection = Collection.new("test_dir")
    entries = collection.entry_list("test_dir")
    assert(["file1.txt", "level_two"].all? { |file| entries.include?(file) })
  end

  def test_04_flatten_moves_all_files_to_root_and_removes_subdirectories
    collection = Collection.new("test_dir")
    collection.flatten
    entries = collection.entry_list("test_dir")
    assert(["file1.txt", "file2.txt", "file3.txt"].all? { |file| entries.include?(file) })
    `mkdir -p test_dir/level_two/level_three`
    `mv test_dir/file2.txt test_dir/level_two`
    `mv test_dir/file3.txt test_dir/level_two/level_three`
  end

  def test_05_unique_name_returns_unique_filepath
    collection = Collection.new("test_dir2")
    new_filepath = collection.unique_name("test_dir2/07 Capital G.mp3")
    assert_equal("test_dir2/07 Capital G-1.mp3", new_filepath)
  end

  def test_06_create_path_creates_new_artist_and_album_folders
    collection = Collection.new("test_dir2")
    metadata = {:artist => "AFI", :album => "Sing The Sorrow"}
    collection.create_path(metadata)
    assert(Dir.exist?("test_dir2/AFI/Sing The Sorrow"))
    `rm -r test_dir2/AFI`
  end

  def test_07_create_path_adds_album_folders_to_existing_artist_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "The Downward Spiral"}
    collection.create_path(metadata)
    assert(Dir.exist?("test_dir2/Nine Inch Nails/The Downward Spiral"))
    `rm -r test_dir2/"Nine Inch Nails"/"The Downward Spiral"`
  end

  def test_08_create_path_does_not_duplicate_folders
    assert(Dir.exist?("test_dir2/Nine Inch Nails/Year Zero"))
    collection = Collection.new("test_dir2")
    metadata = {:artist => "Nine Inch Nails", :album => "Year Zero"}
    collection.create_path(metadata)
    assert_equal(["Year Zero"], collection.entry_list("test_dir2/Nine Inch Nails"))
  end

  def test_09_move_track_moves_track_into_album_folder
    collection = Collection.new("test_dir2")
    new_path = "test_dir2/Nine Inch Nails/Year Zero"
    collection.move_track("test_dir2/07 Capital G.mp3", new_path)
    assert(File.exist?("test_dir2/Nine Inch Nails/Year Zero/07 Capital G.mp3"))
    `mv test_dir2/"Nine Inch Nails"/"Year Zero"/"07 Capital G.mp3" test_dir2`
  end

  def test_10_move_track_creates_unique_filepath_for_duplicate_tracks
    collection = Collection.new("test_dir2")
    new_path = "test_dir2/Nine Inch Nails/Year Zero"
    collection.move_track("test_dir2/05 Vessel.mp3", new_path)
    entries = collection.entry_list("test_dir2/Nine Inch Nails/Year Zero")
    assert(["05 Vessel-1.mp3", "05 Vessel.mp3"].all? { |file| entries.include?(file) })
    `mv test_dir2/"Nine Inch Nails"/"Year Zero"/"05 Vessel-1.mp3" test_dir2/"05 Vessel.mp3"`
  end

  def test_11_organize_removes_current_file_structure
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

  def test_12_organize_creates_new_artist_and_album_folders
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

  def test_13_organize_renames_tracks_and_moves_them_into_album_folders
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

end