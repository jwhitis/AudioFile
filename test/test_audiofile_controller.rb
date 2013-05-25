require "test_helper"

class AudioFileControllerUnitTest < Test::Unit::TestCase

  def test_01_stores_collection
    controller = AudioFileController.new("test_dir3")
    collection = controller.collection
    assert_equal("test_dir3", collection.directory)
  end

  def test_02_execute_creates_new_user_if_none_exist
    User.destroy_all
    assert_equal(User.count, 0)
    controller = AudioFileController.new("test_dir3")
    controller.execute
    assert_equal(User.count, 1)
  end

  def test_03_execute_uses_gracenote_id_of_existing_user
    assert_equal(User.count, 1)
    controller = AudioFileController.new("test_dir3")
    controller.execute
    assert_equal(User.count, 1)
  end

  def test_04_execute_organizes_collection_by_artist_and_album
    controller = AudioFileController.new("test_dir3")
    controller.execute
    assert(File.exist?("test_dir3/Motion City Soundtrack/I Am The Movie/03 The Future Freaks Me Out.mp3"))
    controller.collection.flatten
    `mkdir -p test_dir3/"Michael Jackson"/Thriller`
    `mkdir test_dir3/"Sunny Day Real Estate"`
    `mv test_dir3/"03 The Future Freaks Me Out.mp3" test_dir3/"Michael Jackson"/Thriller`
    `mv test_dir3/"01 Seven.mp3" test_dir3/"Sunny Day Real Estate"`
  end

end