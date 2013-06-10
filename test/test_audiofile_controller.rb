require "test_helper"

class AudioFileControllerUnitTest < Test::Unit::TestCase

  def test_01_stores_collection
    controller = AudioFileController.new("test_dir3")
    collection = controller.collection
    assert(collection.is_a?(Collection))
  end

  def test_02_new_user_returns_boolean_value
    controller = AudioFileController.new("test_dir3")
    assert_equal(true, controller.new_user?)
    User.create
    assert_equal(false, controller.new_user?)
  end

  def test_03_api_requests_new_gracenote_id_if_no_users_exist
    controller = AudioFileController.new("test_dir3")
    user_id = controller.api.user_id
    assert(user_id.is_a?(String) && !user_id.empty?)
  end

  def test_04_api_uses_gracenote_id_of_existing_user
    User.create(gracenote_id: "XXXX-XXXX")
    controller = AudioFileController.new("test_dir3")
    assert_equal("XXXX-XXXX", controller.api.user_id)
  end

  def test_05_execute_creates_new_user_if_none_exist
    assert_equal(0, User.count)
    controller = AudioFileController.new("test_dir3")
    controller.execute
    assert_equal(1, User.count)
  end

  def test_06_execute_organizes_collection_by_artist_and_album
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