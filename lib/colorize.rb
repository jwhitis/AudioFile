module Colorize

  BLACK   = 30
  RED     = 31
  GREEN   = 32
  YELLOW  = 33
  BLUE    = 34
  MAGENTA = 35
  CYAN    = 36
  WHITE   = 37

  def colorize color
    "\e[#{color}m#{self}\e[0m"
  end

end