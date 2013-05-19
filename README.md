# AudioFile

### Purpose

The purpose of this application is to provide users with a convenient command line utility for editing metadata tags on audio files and then organizing those files into subdirectories based on the contents of the metadata tags. This functionality is modeled after a number of existing GUI and command line apps, including Apple's iTunes.

This app will be my capstone project for the Ruby portion of the Nashville Software School. For this assignment, we are limited to using standard library Ruby with the goal of demonstrating proficiency in the language. One exception to this limitation is the ability to use ActiveRecord as an Object Relational Mapping system.

### Project Status

This project is in the initial planning phase. I am currently determining what tools I will need to achieve the desired functionality, including a library for editing metadata tags and an API from which to retrieve song data.

### Features

Proposed features:

* Inspects metadata tags for each audio file in a given directory
* Uses existing metadata to request complete song data from an online music service
* Uses returned song data to complete or correct metadata tags
* Organizes songs from the same album into a new subdirectory
* Organizes albums from the same artist into a new subdirectory
* Supplies users with metadata pertaining to the entire collection, including the number of artists, albums, songs, and total runtime
* Completes the aforementioned tasks with minimal user interaction

### Usage

Usage for this app is to be determined.

### Demo

A demo of this app is currently unavailable.

### Known Bugs

None currently; this will be updated periodically as I begin writing code.

### Author

Jack Whitis

### Changelog

5/9/2013 - Created README and user stories.

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