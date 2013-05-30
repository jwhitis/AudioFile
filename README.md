# AudioFile

### Purpose

The purpose of this application is to provide users with a convenient command line utility that automatically updates the metadata tags on audio files in a given directory and then organizes them into subdirectories by artist and album name. This functionality is modeled after a number of existing GUI and command line apps, including Apple's iTunes.

This app is my capstone project for the Ruby portion of the Nashville Software School. For this assignment, we are limited to using standard library Ruby with the goal of demonstrating proficiency in the language. As an exception, this app utilizes <a href="http://edgeguides.rubyonrails.org/active_record_basics.html">Active Record</a> as an object relational mapping system and <a href="http://robinst.github.io/taglib-ruby/">taglib-ruby</a>, a wrapper for the C++ metadata library <a href="http://taglib.github.io/">TagLib</a>.

### Project Status

[![Build Status](https://www.travis-ci.org/jwhitis/AudioFile.png?branch=master)](https://www.travis-ci.org/jwhitis/AudioFile)

This project has reached a point of stability and incorporates the minimum required feature set. All existing features are fully supported by tests. Features for future implementation include the following:

* Stores the value of each metadata property for each track in a database
* Generates a text document containing the contents of the database
* Upon request, outputs collection information, such as the total number of number of artists, albums, songs, and runtime

### Current Features

* Dismantles existing file structure within a given directory
* Inspects metadata tags for each audio file in the directory
* Outputs error messages for metadata tags that cannot be opened
* Uses existing metadata to request complete song data from an online music service
* Queries music service using filename if no metadata exists
* Outputs error messages for queries that are invalid or return no matches
* Uses returned song data to complete or correct metadata tags
* Organizes songs from the same album into a new subdirectory
* Organizes albums from the same artist into a new subdirectory
* Utilizes intuitive, color-coded user interface

### Installation

Before installing the gem dependencies, make sure to install TagLib:

* Debian/Ubuntu: `sudo apt-get install libtag1-dev`
* Fedora/RHEL: `sudo yum install taglib-devel`
* Brew: `brew install taglib`
* MacPorts: `sudo port install taglib`

It is possible that if you run `bundle install` at this point, you will receive an error message stating that you haven't installed TagLib, yet. If this happens, try running:

    CONFIGURE_ARGS="--with-opt-dir=PATH" gem install taglib-ruby

...replacing PATH with the location of include/taglib/taglib.h on your computer. Once taglib-ruby is installed, you can install the remaining dependencies using `bundle install`.

### Usage

To run AudioFile:

* `cd` into the AudioFile directory
* run `./audiofile.rb`

You will be prompted to enter the full path of the directory you wish to organize. If you do not enter a valid directory, you will be asked to either enter another directory path or exit the program.

Once you have entered a valid directory and confirmed that you wish to organize it, the program will execute with no further input required. You may occasionally see messages indicating that certain files could not be organized. This is normal, and the program will continue running until all of the files have been processed. If you wish to stop the program prematurely, you will have to kill it manually.

### Performance

AudioFile utilizes the <a href="https://developer.gracenote.com/web-api">Gracenote Music Metadata</a> API, which accepts queries containing partial song information and returns complete metadata, including artist and album name, track number, and release year. The accuracy of its responses are entirely dependent upon the quality of the query. In AudioFile, the query is derived from the existing metadata, the filename, or some combination of the two. As a result, the more complete the existing metadata, the better the chance that Gracenote will return the correct information.

If a file contains no metadata, its filename is used as the basis of the query. In this case, results are best when the filename contains only the song title. Gracenote returns matches in order of accuracy and popularity, and AudioFile uses the first one that it receives.

In my experience testing the program, success rates have exceeded 60% for worst-case scenarios and 90% for more desirable conditions. My suggestion is that you process the files in batches so that you can catch and correct errors as they occur.

### Additional Notes

AudioFile is destructive in the sense that it dismantles the existing file structure of the directory and builds a new one from scratch. Subdirectories are created and filenames are overwritten based on the metadata that Gracenote returns. **For this reason, it is highly recommended that you back up your directory before executing the program.**

The tests rely on several test directories, which contain dummy files that the tests manipulate. These directories reside in the root of the project folder. In order for the tests to run correctly, both the Rakefile and these directories must remain in project root.

### Author

Jack Whitis

### Changelog

5/9/2013 - Created README and user stories.  
5/27/2013 - Committed first usable iteration of the application.

### License

Copyright (c) 2013 Jack Whitis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.