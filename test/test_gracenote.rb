require "test_helper"
require "rexml/document"

class GracenoteUnitTest < Test::Unit::TestCase

  def test_01_stores_client_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    assert_equal(client_id, api.client_id)
  end

  def test_02_stores_existing_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    user_id = "XXXX-XXXX"
    api = Gracenote.new(client_id, user_id)
    assert_equal(user_id, api.user_id)
  end

  def test_03_stores_new_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    user_id = api.user_id
    assert(user_id.is_a?(String) && !user_id.empty?)
  end

  def test_04_get_user_id_returns_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    user_id = api.get_user_id
    assert(user_id.is_a?(String) && !user_id.empty?)
  end

  def test_05_registration_returns_xml_registration_query
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    expected =
"<QUERIES>
  <QUERY CMD='REGISTER'>
    <CLIENT>#{client_id}</CLIENT>
  </QUERY>
</QUERIES>"
    assert_equal(expected, api.registration)
  end

  def test_06_get_xml_returns_xml_document
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "Dave Matthews Band",
      :album => "Everyday",
      :title => "The Space Between"
    }
    query = api.query(metadata)
    doc =  api.get_xml(query)
    assert(doc.is_a?(REXML::Document))
  end

  def test_07_http_returns_http_object
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    http = api.http
    assert(http.is_a?(Net::HTTP))
  end

  def test_08_url_returns_api_url
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    expected = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    assert_equal(expected, api.url)
  end

  def test_09_query_returns_xml_search_query
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "The Deftones",
      :album => "Around the Fur",
      :title => "Be Quiet and Drive"
    }
    expected =
"<QUERIES>
  <LANG>eng</LANG>
  <AUTH>
    <CLIENT>#{api.client_id}</CLIENT>
    <USER>#{api.user_id}</USER>
  </AUTH>
  <QUERY CMD='ALBUM_SEARCH'>
    <MODE>SINGLE_BEST</MODE>
    <TEXT TYPE='ARTIST'>The Deftones</TEXT>
    <TEXT TYPE='ALBUM_TITLE'>Around the Fur</TEXT>
    <TEXT TYPE='TRACK_TITLE'>Be Quiet and Drive</TEXT>
  </QUERY>
</QUERIES>"
    assert_equal(expected, api.query(metadata))
  end

  def test_10_search_returns_hash_with_song_title
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "At The Drive-In",
      :album => "Relationship Of Command",
      :title => "Enfilade"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal("Enfilade", metadata[:title])
  end

  def test_11_search_returns_hash_with_artist_name
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "Nada Surf",
      :album => "Let Go",
      :title => "Inside Of Love"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal("Nada Surf", metadata[:artist])
  end

  def test_12_search_returns_hash_with_album_name
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "The Police",
      :album => "Synchronicity",
      :title => "Wrapped Around Your Finger"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal("Synchronicity", metadata[:album])
  end

  def test_13_search_returns_hash_with_track_number
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "Social Distortion",
      :album => "Social Distortion",
      :title => "Story Of My Life"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal(3, metadata[:track])
  end

  def test_14_search_returns_hash_with_year
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "The Wallflowers",
      :album => "Bringing Down The Horse",
      :title => "The Difference"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal(1996, metadata[:year])
  end

  def test_15_search_returns_hash_with_genre
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "Tears For Fears",
      :album => "Songs From The Big Chair",
      :title => "Shout"
    }
    query = api.query(metadata)
    metadata =  api.search(query)
    assert_equal("New Romantic", metadata[:genre])
  end

  def test_16_search_returns_error_message_if_status_code_is_no_match
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {:title => "a1s2d3f4g5h6j7k8l9"}
    query = api.query(metadata)
    assert_equal("No matches for query.", api.search(query))
  end

  def test_17_search_returns_error_message_if_status_code_is_error
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    query = "<QUERIES>MISSING DATA<QUERIES>"
    assert_equal("Invalid query.", api.search(query))
  end

  def test_18_metadata_returns_a_hash_of_metadata
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "Meat Puppets",
      :album => "Too High To Die", 
      :title => "Backwater"
    }
    query = api.query(metadata)
    doc = api.get_xml(query)
    metadata = api.metadata(doc)
    assert_equal("Backwater", metadata[:title])
  end

end