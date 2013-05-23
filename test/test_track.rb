require "test_helper"
require "taglib"

class TrackUnitTest < Test::Unit::TestCase

  def test_a1_stores_filepath
    track = Track.new("test_audio/test.mp3")
    assert_equal("test_audio/test.mp3", track.filepath)
  end

  def test_a2_stores_metadata
    track = Track.new("test_audio/test.mp3")
    track.metadata = {:title => "I Will Possess Your Heart"}
    assert_equal({:title => "I Will Possess Your Heart"}, track.metadata)
  end

  def test_a3_read_tag_returns_a_hash_of_metadata
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert(metadata.is_a?(Hash))
  end

  def test_a4_metadata_hash_contains_song_title
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Hanging On The Telephone", metadata[:title])
  end

  def test_a5_metadata_hash_contains_artist_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("The Nerves", metadata[:artist])
  end

  def test_a6_metadata_hash_contains_album_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("One Way Ticket", metadata[:album])
  end

  def test_a7_metadata_hash_contains_track_number
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(3, metadata[:track])
  end

  def test_a8_metadata_hash_contains_release_year
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(2008, metadata[:year])
  end

  def test_a9_metadata_hash_contains_musical_genre
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Powerpop", metadata[:genre])
  end

  def test_a10_metadata_hash_contains_additional_comments
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Comment goes here", metadata[:comment])
  end

  def test_a11_title_from_filepath_removes_directory_and_extension
    track = Track.new("test_audio/test.mp3")
    assert_equal("test", track.title_from_filepath)
  end

  def test_a12_title_from_filepath_removes_leading_digits_and_whitespace
    track = Track.new("test_audio/01 This Is Not My Life.mp3")
    assert_equal("This Is Not My Life", track.title_from_filepath)
  end

  def test_a13_title_from_filepath_replaces_hyphens_and_underscores
    track = Track.new("test_audio/02 - Lucky_Denver_Mint.mp3")
    assert_equal("Lucky Denver Mint", track.title_from_filepath)
  end

  def test_a14_title_from_filepath_changes_metadata_instance_variable
    track = Track.new("test_audio/01 Last One Out Of Liberty City.mp3")
    track.title_from_filepath
    assert_equal("Last One Out Of Liberty City", track.metadata[:title])
  end

  def test_a15_get_metadata_returns_a_hash_of_metadata
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

  def test_a16_get_metadata_updates_metadata_instance_variable
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

  def test_a17_write_tag_sets_title_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:title => "Paper Dolls"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Paper Dolls", fileref.tag.title)
    end
  end

  def test_a18_write_tag_sets_artist_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:artist => "The Nerves"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("The Nerves", fileref.tag.artist)
    end
  end

  def test_a19_write_tag_sets_album_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:album => "One Way Ticket"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("One Way Ticket", fileref.tag.album)
    end
  end

  def test_a20_write_tag_sets_track_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:track => 2}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2, fileref.tag.track)
    end
  end

  def test_a21_write_tag_sets_year_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:year => 2008}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2008, fileref.tag.year)
    end
  end

  def test_a22_write_tag_sets_genre_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:genre => "Powerpop"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Powerpop", fileref.tag.genre)
    end
  end

  def test_a23_write_tag_sets_comment_property
    track = Track.new("test_audio/write_test.mp3")
    track.metadata = {:comment => "Comment goes here"}
    track.write_tag
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Comment goes here", fileref.tag.comment)
    end
  end

  def test_a24_rename_changes_filename
    track = Track.new("test_audio/rename_test.mp3")
    track.metadata = {:title => "People Of The Sun", :track => 1}
    track.rename
    assert(File.exist?("test_audio/01 People Of The Sun.mp3"))
    `mv test_audio/"01 People Of The Sun.mp3" test_audio/rename_test.mp3`
  end

  def test_a25_rename_changes_filepath_instance_variable
    track = Track.new("test_audio/rename_test.mp3")
    track.metadata = {:title => "The Impression That I Get", :track => 4}
    track.rename
    assert_equal("test_audio/04 The Impression That I Get.mp3", track.filepath)
    `mv test_audio/"04 The Impression That I Get.mp3" test_audio/rename_test.mp3`
  end

  def test_a26_update_changes_filename
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert(File.exist?("test_audio/04 When you Find Out.mp3"))
    `mv test_audio/"04 When You Find Out.mp3" test_audio/update_test.mp3`
  end

  def test_a27_update_changes_filepath_instance_variable
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert_equal("test_audio/04 When You Find Out.mp3", track.filepath)
    `mv test_audio/"04 When You Find Out.mp3" test_audio/update_test.mp3`
  end

  def test_a28_update_sets_metadata_tag_properties
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    TagLib::FileRef.open("test_audio/04 When You Find Out.mp3") do |fileref|
      assert_equal(4, fileref.tag.track)
    end
    `mv test_audio/"04 When You Find Out.mp3" test_audio/update_test.mp3`
  end

  def test_a29_update_changes_metadata_instance_variable
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    track = Track.new("test_audio/update_test.mp3")
    track.update(api)
    assert_equal(2008, track.metadata[:year])
    `mv test_audio/"04 When You Find Out.mp3" test_audio/update_test.mp3`
  end

end