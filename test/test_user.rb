require "test_helper"

class UserUnitTest < Test::Unit::TestCase

  def test_c01_creates_new_user_record
    User.destroy_all
    assert_equal(User.count, 0)
    User.create
    assert_equal(User.count, 1)
  end

  def test_c02_stores_gracenote_id
    user = User.create(gracenote_id: "XXXX-XXXX")
    assert_equal("XXXX-XXXX", user.gracenote_id)
  end

end