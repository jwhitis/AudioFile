require "test/unit"
require "./lib/track.rb"
require "taglib"

class TrackUnitTest < Test::Unit::TestCase

  def test_a1_stores_filepath
    track = Track.new("test_audio/read_test.mp3")
    assert_equal("test_audio/read_test.mp3", track.filepath)
  end

  def test_a2_read_tag_returns_a_hash_of_metadata
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert(metadata.is_a?(Hash))
  end

  def test_a3_metadata_hash_contains_song_title
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Hanging On The Telephone", metadata[:title])
  end

  def test_a4_metadata_hash_contains_artist_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("The Nerves", metadata[:artist])
  end

  def test_a5_metadata_hash_contains_album_name
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("One Way Ticket", metadata[:album])
  end

  def test_a6_metadata_hash_contains_track_number
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(3, metadata[:track])
  end

  def test_a7_metadata_hash_contains_release_year
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal(2008, metadata[:year])
  end

  def test_a8_metadata_hash_contains_musical_genre
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Powerpop", metadata[:genre])
  end

  def test_a9_metadata_hash_contains_additional_comments
    track = Track.new("test_audio/read_test.mp3")
    metadata = track.read_tag
    assert_equal("Comment goes here", metadata[:comment])
  end

  def test_a10_write_tag_sets_title_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:title => "Paper Dolls"}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Paper Dolls", fileref.tag.title)
    end
  end

  def test_a11_write_tag_sets_artist_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:artist => "The Nerves"}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("The Nerves", fileref.tag.artist)
    end
  end

  def test_a12_write_tag_sets_album_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:album => "One Way Ticket"}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("One Way Ticket", fileref.tag.album)
    end
  end

  def test_a13_write_tag_sets_track_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:track => 2}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2, fileref.tag.track)
    end
  end

  def test_a14_write_tag_sets_year_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:year => 2008}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal(2008, fileref.tag.year)
    end
  end

  def test_a15_write_tag_sets_genre_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:genre => "Powerpop"}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Powerpop", fileref.tag.genre)
    end
  end

  def test_a16_write_tag_sets_comment_property
    track = Track.new("test_audio/write_test.mp3")
    metadata = {:comment => "Comment goes here"}
    track.write_tag(metadata)
    TagLib::FileRef.open("test_audio/write_test.mp3") do |fileref|
      assert_equal("Comment goes here", fileref.tag.comment)
    end
  end

  def test_a17_rename_changes_filepath
    track = Track.new("test_audio/rename_test.mp3")
    metadata = {:title => "People Of The Sun", :track => 1}
    track.rename(metadata)
    assert(File.exist?("test_audio/01 People Of The Sun.mp3"))
    `mv test_audio/"01 People Of The Sun.mp3" test_audio/rename_test.mp3`
  end

  def test_a18_rename_updates_filepath_instance_variable
    track = Track.new("test_audio/rename_test.mp3")
    metadata = {:title => "The Impression That I Get", :track => 4}
    track.rename(metadata)
    assert_equal("test_audio/04 The Impression That I Get.mp3", track.filepath)
    `mv test_audio/"04 The Impression That I Get.mp3" test_audio/rename_test.mp3`
  end

end