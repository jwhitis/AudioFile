# User Stories

<hr />

As a general user  
In order to organize the audio files in a given directory  
I want to analyze every audio file in that directory

* The user calls `audiofile` from the command line
* The program should ask if the user wants to continue sorting the directory
* The program should perform a series of actions on each audio file in the directory 

<hr />

As a general user  
In order to ascertain what I currently know about each audio file  
I want to extract information from the filename and metadata tag of each audio file

* Information should be extracted from each audio file

<hr />

As a general user  
In order to accurately organize songs with incomplete documentation  
I want to send the information I extracted from each audio file to an API, which will return complete details for each song

For each audio file:

* Extracted information should be formatted into an XML string
* The XML string should be sent with an HTTP request to the API
* The API should return complete song data for the audio file
* The metadata tag of the audio file should be edited to reflect the retrieved song data

<hr />

As a general user  
In order to prevent misorganization of audio files  
I want to be prompted when there are no matches for a song and given the opportunity to manually enter information myself

* When there are no matches for a song, the program should ask if the user wants to enter the metadata manually
* If the user responds "yes", the program should provide the user with a prompt for each field in the metadata tag
* If the user responds "no", the program should skip over the audio file and take no action

<hr />

As a general user  
In order to persist information retrieved from the API  
I want to edit the metadata tag of each audio file, filling in the fields with information returned by the API

* The metadata tag of the audio file should be edited to reflect the retrieved song data
* Each tag should contain, at minimum, the artist name, album name, song name, and track number

<hr />

As a general user  
In order to make the audio files easily identifiable  
I want to edit the filename of each audio file, using a standardized format that includes the track number and song name

* The filename of each audio file should be edited so that it takes the following format: track_number - song_name

<hr />

As a general user  
In order to make the audio files easily searchable  
I want to group songs from the same album into a subfolder named after that album

* Each audio file with complete song data should be moved into the album subfolder containing other songs from that album
* If no such folder exists, one should be created, and then the audio file should be moved into it

<hr />

As a general user  
In order to make the audio files easily searchable  
I want to group albums by the same artist into a subfolder named after that artist

* Each album subfolder should be moved into the artist subfolder containing other albums by that artist
* If no such folder exists, one should be created, and then the album subfolder should be moved into it

<hr />

As a general user  
In order to satisfy my curiosity regarding the size and state of my music collection  
I want to access metadata for my collection, including the number of artists, albums, songs, and total runtime

* The user calls `audiofile` from the command line, passing an argument that represents the type of data being requested
* The program should output the requested value to the terminal