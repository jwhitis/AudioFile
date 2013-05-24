require "test_helper"

class GracenoteUnitTest < Test::Unit::TestCase

  def test_b01_stores_client_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    assert_equal(client_id, api.client_id)
  end

  def test_b02_stores_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    user_id = api.user_id
    assert(user_id.is_a?(String))
    assert(!user_id.empty?)
  end

  def test_b03_url_returns_api_url
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    api = Gracenote.new(client_id)
    assert_equal(url, api.url)
  end

  def test_b04_query_returns_formatted_xml_query
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    query = "<QUERIES>
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
    metadata = {
      :artist => "The Deftones",
      :album => "Around the Fur",
      :title => "Be Quiet and Drive"}
    assert_equal(query, api.query(metadata))
  end

  def test_b05_search_returns_a_hash_of_metadata
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {
      :artist => "The Deftones",
      :album => "Around the Fur", 
      :title => "Be Quiet and Drive"
    }
    query = api.query(metadata)
    metadata = api.search(query)
    assert(metadata.is_a?(Hash))
  end

  def test_b06_metadata_hash_contains_song_title
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

  def test_b07_metadata_hash_contains_artist_name
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

  def test_b08_metadata_hash_contains_album_name
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

  def test_b09_metadata_hash_contains_track_number
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

  def test_b10_metadata_hash_contains_year
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

  def test_b11_metadata_hash_contains_genre
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

end