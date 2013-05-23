module Formatter

  BLACK   = 30
  RED     = 31
  GREEN   = 32
  YELLOW  = 33
  BLUE    = 34
  MAGENTA = 35
  CYAN    = 36
  WHITE   = 37

  def colorize color
    "\e[#{color}m#{self}"
  end

########## Fix bug with escaping apostrophes! ##########
  # def justify width
  #   words = self.split
  #   lines = []
  #   until words.empty?
  #     line = ""
  #     while line.length < width
  #       if "#{line}#{words.first}".length <= width
  #         line += "#{words.shift}"
  #         line += " " if "#{line} ".length <= width
  #       else
  #         break
  #       end
  #     end
  #     lines << line.rstrip!
  #   end
  #   lines.join("\n")
  # end

end