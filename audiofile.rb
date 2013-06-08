#!/usr/bin/env ruby

require "./bootstrap_ar.rb"
include Colorize

puts " Welcome to AudioFile ".center(65, "*").colorize(GREEN)
puts "Please enter the full path of the directory you wish to organize."
puts "Otherwise, type 'exit' to leave the program."
while true
  response = gets.chomp!
  if response.downcase == "exit"
    exit
  else
    controller = AudioFileController.new(response)
    directory = controller.collection.directory
    if directory.is_a?(Hash)
      puts directory[:error].colorize(RED)
      puts "Please enter another directory path, or type 'exit' to leave the program."
      next
    end
  end
  puts "It is recommended that you back up your directory before proceeding.".colorize(YELLOW)
  puts "Do you wish to continue? [y/n]"
  while true
    continue = gets.downcase.chomp!
    if continue == "y"
      puts "Working...".colorize(CYAN)
      controller.execute
      puts "Finished!".colorize(GREEN)
      exit
    elsif continue == "n"
      puts "Please enter another directory path, or type 'exit' to leave the program."
      break
    else
      puts "Do you wish to continue? [y/n]"
    end
  end
end