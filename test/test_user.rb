require "test_helper"

class UserUnitTest < Test::Unit::TestCase

  def test_01_creates_new_user_record
    assert_equal(0, User.count)
    User.create
    assert_equal(1, User.count)
  end

  def test_02_stores_gracenote_id
    user = User.create(gracenote_id: "XXXX-XXXX")
    assert_equal("XXXX-XXXX", user.gracenote_id)
  end

end