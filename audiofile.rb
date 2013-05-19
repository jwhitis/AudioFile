require "./lib/track.rb"
require "./lib/gracenote.rb"

track = Track.new("test.mp3")
puts track.read_tag("test.mp3")