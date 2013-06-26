require "test_helper"
include Colorize

class ColorizeUnitTest < Test::Unit::TestCase

  def test_01_colorize_returns_color_coded_text
    text = "Some green text."
    expected = "\e[32mSome green text.\e[0m"
    assert_equal(expected, text.colorize(GREEN))
  end

end