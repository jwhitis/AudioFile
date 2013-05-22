require "net/http"
require "rexml/document"

class Gracenote
  attr_reader :client_id
  attr_reader :user_id

  def initialize client_id
    @client_id = client_id
    query = "<QUERIES>
              <QUERY CMD='REGISTER'>
                <CLIENT>#{client_id}</CLIENT>
              </QUERY>
            </QUERIES>"
    response = http.request_post(url, query)
    doc = REXML::Document.new(response.body)
    @user_id = doc.elements["RESPONSES/RESPONSE/USER"].text
  end

  def http
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http
  end

  def url
    "https://c#{client_id.split("-").first}.web.cddbp.net/webapi/xml/1.0/"
  end

  def query metadata
    "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>#{client_id}</CLIENT>
        <USER>#{user_id}</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>#{metadata[:artist]}</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>#{metadata[:album]}</TEXT>
        <TEXT TYPE='TRACK_TITLE'>#{metadata[:title]}</TEXT>
      </QUERY>
    </QUERIES>"
  end

  def search query
    response = http.request_post(url, query)
    doc = REXML::Document.new(response.body)
    metadata = Hash.new
    metadata[:artist] = doc.elements["RESPONSES/RESPONSE/ALBUM/ARTIST"].text
    metadata[:album] = doc.elements["RESPONSES/RESPONSE/ALBUM/TITLE"].text
    metadata[:title] = doc.elements["RESPONSES/RESPONSE/ALBUM/TRACK/TITLE"].text
    metadata[:track] = doc.elements["RESPONSES/RESPONSE/ALBUM/TRACK/TRACK_NUM"].text.to_i
    metadata[:year] = doc.elements["RESPONSES/RESPONSE/ALBUM/DATE"].text.to_i
    metadata[:genre] = doc.elements["RESPONSES/RESPONSE/ALBUM/GENRE"].text
    metadata
  end

end