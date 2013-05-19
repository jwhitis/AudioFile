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
    url = URI.parse(url(client_id))
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.start do |agent|
      response = agent.post(url.path, query)
      doc = REXML::Document.new(response.body)
      @user_id = doc.elements["RESPONSES/RESPONSE/USER"].text
    end
  end

  def url client_id
    "https://c#{client_id.split("-").first}.web.cddbp.net/webapi/xml/1.0/"
  end

  def query client_id, user_id, metadata
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

  def search url, query
    metadata = Hash.new
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.ssl_version = :SSLv3
    http.start do |agent|
      response = agent.post(url.path, query)
      doc = REXML::Document.new(response.body)
      metadata[:artist] = doc.elements["RESPONSES/RESPONSE/ALBUM/ARTIST"].text
      metadata[:album] = doc.elements["RESPONSES/RESPONSE/ALBUM/TITLE"].text
      metadata[:title] = doc.elements["RESPONSES/RESPONSE/ALBUM/TRACK/TITLE"].text
      metadata[:track] = doc.elements["RESPONSES/RESPONSE/ALBUM/TRACK/TRACK_NUM"].text.to_i
      metadata[:year] = doc.elements["RESPONSES/RESPONSE/ALBUM/DATE"].text.to_i
      metadata[:genre] = doc.elements["RESPONSES/RESPONSE/ALBUM/GENRE"].text
    end
    metadata
  end

end # Gracenote class