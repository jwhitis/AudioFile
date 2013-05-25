require "net/http"
require "rexml/document"

class Gracenote
  attr_reader :client_id
  attr_reader :user_id

  PROPERTIES = {
    :artist => "ARTIST",
    :album => "TITLE",
    :title => "TRACK/TITLE",
    :track => "TRACK/TRACK_NUM",
    :year => "DATE",
    :genre => "GENRE"
  }

  def initialize client_id, user_id = nil
    @client_id = client_id
    if user_id.nil?
      query = "<QUERIES>
                <QUERY CMD='REGISTER'>
                  <CLIENT>#{client_id}</CLIENT>
                </QUERY>
              </QUERIES>"
      response = http.request_post(url, query)
      doc = REXML::Document.new(response.body)
      @user_id = doc.elements["RESPONSES/RESPONSE/USER"].text
    else
      @user_id = user_id
    end
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
    </QUERIES>".gsub("&", "and")
  end

  def search query
    response = http.request_post(url, query)
    doc = REXML::Document.new(response.body)
    if doc.elements["*/RESPONSE"].attributes["STATUS"] == "NO_MATCH"
      raise ArgumentError, "No matches for query:\n#{query}"
    elsif doc.elements["*/RESPONSE"].attributes["STATUS"] == "ERROR"
      raise ArgumentError, "Bad query - #{doc.elements["*/MESSAGE"].text}\n#{query}"
    end
    metadata = {}
    PROPERTIES.keys.each do |property|
      unless doc.elements["*/*/ALBUM/#{PROPERTIES[property]}"].nil?
        metadata[property] = doc.elements["*/*/ALBUM/#{PROPERTIES[property]}"].text
        metadata[property] = metadata[property].gsub("/", "-")
        if property == :track || property == :year
          metadata[property] = metadata[property].to_i
        end
      end
    end
    metadata
  end

end