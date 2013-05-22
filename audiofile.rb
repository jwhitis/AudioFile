require "./bootstrap_ar.rb"

puts "Welcome to AudioFile. Please enter the full path of the directory you wish to organize. Otherwise, type 'exit' to leave the program."
while true
  response = gets.chomp!
  if response.downcase == "exit"
    exit
  else
    begin
      controller = AudioFileController.new(response)
    rescue ArgumentError => error
      puts "#{error.message} Please enter another directory path, or type 'exit' to leave the program."
      next
    end
  end
  puts "It is recommended that you back up your directory before proceeding. Do you wish to continue? [y/n]"
  while true
    continue = gets.downcase.chomp!
    if continue == "y"
      puts "Working..."
      controller.execute
      puts "Finished!"
      exit
    elsif continue == "n"
      puts "Please enter another directory path, or type 'exit' to leave the program."
      break
    else
      puts "Do you wish to continue? [y/n]"
    end
  end
end