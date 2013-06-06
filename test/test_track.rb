require "test_helper"
require "taglib"

class TrackUnitTest < Test::Unit::TestCase

  def test_01_stores_filepath
    track = Track.new("test_audio/test.mp3")
    assert_equal("test_audio/test.mp3", track.filepath)
  end

  def test_02_stores_metadata
    track = Track.new("test_audio/test.mp3")
    track.metadata = {:title => "I Will Possess Your Heart"}
    assert_equal({:title => "I Will Possess Your Heart"}, track.metadata)
  end

  def test_03_read_tag_returns_hash_with_song_title
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Hanging On The Telephone", metadata[:title])
  end

  def test_04_read_tag_returns_hash_with_artist_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("The Nerves", metadata[:artist])
  end

  def test_05_read_tag_returns_hash_with_album_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("One Way Ticket", metadata[:album])
  end

  def test_06_read_tag_returns_hash_with_track_number
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(3, metadata[:track])
  end

  def test_07_read_tag_returns_hash_with_release_year
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(2008, metadata[:year])
  end

  def test_08_read_tag_returns_hash_with_musical_genre
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Powerpop", metadata[:genre])
  end

  def test_09_read_tag_returns_hash_with_additional_comments
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Comment goes here", metadata[:comment])
  end

  def test_10_write_tag_sets_title_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:title => "Paper Dolls"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Paper Dolls", fileref.tag.title)
    end
  end

  def test_11_write_tag_sets_artist_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:artist => "The Nerves"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("The Nerves", fileref.tag.artist)
    end
  end

  def test_12_write_tag_sets_album_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:album => "One Way Ticket"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("One Way Ticket", fileref.tag.album)
    end
  end

  def test_13_write_tag_sets_track_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:track => 2}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2, fileref.tag.track)
    end
  end

  def test_14_write_tag_sets_year_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:year => 2008}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2008, fileref.tag.year)
    end
  end

  def test_15_write_tag_sets_genre_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:genre => "Powerpop"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Powerpop", fileref.tag.genre)
    end
  end

  def test_16_write_tag_sets_comment_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:comment => "Comment goes here"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Comment goes here", fileref.tag.comment)
    end
  end

  def test_17_open_tag_returns_error_message_if_tag_cannot_be_opened
    track = Track.new("test_dir/file1.txt")
    expected = {:error => "'file1.txt' cannot be opened."}
    assert_equal(expected, track.read_tag)
  end

  def test_18_process_tag_changes_metadata_instance_variable
    track = Track.new("test_audio/read_test.mp3")
    TagLib::FileRef.open("test_audio/read_test.mp3") do |fileref|
      metadata = track.process_tag(fileref, :read)
      assert_equal(3, track.metadata[:track])
    end
  end

  def test_19_get_properties_returns_hash_of_metadata
    track = Track.new("test_audio/read_test.mp3")
    TagLib::FileRef.open("test_audio/read_test.mp3") do |fileref|
      tag = fileref.tag
      metadata = track.get_properties(tag)
      assert_equal("Hanging On The Telephone", metadata[:title])
    end
  end

  def test_20_set_properties_sets_tag_properties
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:artist => "The Nerves"}
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      tag = fileref.tag
      track.set_properties(tag, fileref)
      assert_equal("Paper Dolls", tag.title)
    end
  end

  def test_21_title_from_filepath_removes_directory_and_extension
    track = Track.new("test_audio/test.mp3")
    track.metadata = {}
    assert_equal("test", track.title_from_filepath)
  end

  def test_22_title_from_filepath_replaces_underscores_with_spaces
    track = Track.new("test_audio/02_Lucky_Denver_Mint.mp3")
    track.metadata = {}
    assert_equal("02 Lucky Denver Mint", track.title_from_filepath)
  end

  def test_23_title_from_filepath_changes_metadata_instance_variable
    track = Track.new("test_audio/01 Last One Out Of Liberty City.mp3")
    track.metadata = {}
    track.title_from_filepath
    assert_equal("01 Last One Out Of Liberty City", track.metadata[:title])
  end

  def test_24_get_metadata_returns_a_hash_of_metadata
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/03 Digital Love.mp3")
    track.metadata = {
      :artist => "Daft Punk",
      :album => "Discovery",
      :title => "Digital Love"
    }
    metadata = track.get_metadata(api)
    assert_equal(3, metadata[:track])
  end

  def test_25_get_metadata_updates_metadata_instance_variable
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/03 Digital Love.mp3")
    track.metadata = {
      :artist => "Daft Punk",
      :album => "Discovery",
      :title => "Digital Love"
    }
    track.get_metadata(api)
    assert_equal(3, track.metadata[:track])
  end

  def test_26_get_metadata_returns_error_message_returned_by_search
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/test.mp3")
    track.metadata = {:title => "a1s2d3f4g5h6j7k8l9"}
    expected = {:error => "No matches for query. 'test.mp3' was skipped."}
    assert_equal(expected, track.get_metadata(api))
  end

  def test_27_format_error_returns_formatted_error
    track = Track.new("test.mp3")
    message = "No matches for query."
    expected = {:error => "No matches for query. 'test.mp3' was skipped."}
    assert_equal(expected, track.format_error(message))
  end

  def test_28_rename_changes_filename
    track = Track.new("test_audio/rename_test.mp3")
    track.metadata = {:title => "People Of The Sun", :track => 1}
    track.rename
    assert(File.exist?("test_audio/01 People Of The Sun.mp3"))
    `mv test_audio/"01 People Of The Sun.mp3" test_audio/rename_test.mp3`
  end

  def test_29_rename_changes_filepath_instance_variable
    track = Track.new("test_audio/rename_test.mp3")
    track.metadata = {:title => "The Impression That I Get", :track => 4}
    track.rename
    assert_equal("test_audio/04 The Impression That I Get.mp3", track.filepath)
    `mv test_audio/"04 The Impression That I Get.mp3" test_audio/rename_test.mp3`
  end

  def test_30_new_filepath_creates_new_filepath_from_metadata
    track = Track.new("test_audio/test.mp3")
    track.metadata = {:title => "Praise Chorus", :track => 2}
    assert_equal("test_audio/02 Praise Chorus.mp3", track.new_filepath)
  end

  def test_31_update_changes_filename
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert(File.exist?("test_audio/05 Working Too Hard.mp3"))
    `mv test_audio/"05 Working Too Hard.mp3" test_audio/update_test.mp3`
  end

  def test_32_update_changes_filepath_instance_variable
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert_equal("test_audio/05 Working Too Hard.mp3", track.filepath)
    `mv test_audio/"05 Working Too Hard.mp3" test_audio/update_test.mp3`
  end

  def test_33_update_sets_metadata_tag_properties
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    TagLib::FileRef.open("test_audio/05 Working Too Hard.mp3") do |fileref|
      assert_equal(5, fileref.tag.track)
    end
    `mv test_audio/"05 Working Too Hard.mp3" test_audio/update_test.mp3`
  end

  def test_34_update_changes_metadata_instance_variable
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert_equal(2008, track.metadata[:year])
    `mv test_audio/"05 Working Too Hard.mp3" test_audio/update_test.mp3`
  end

end