require "test_helper"

class GracenoteUnitTest < Test::Unit::TestCase

  def test_01_stores_client_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    assert_equal(client_id, api.client_id)
  end

  def test_02_stores_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    user_id = api.user_id
    assert(user_id.is_a?(String))
    assert(!user_id.empty?)
  end

  def test_03_url_returns_api_url
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    api = Gracenote.new(client_id)
    assert_equal(url, api.url)
  end

  def test_04_query_returns_formatted_xml_query
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    query =
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
    metadata = {
      :artist => "The Deftones",
      :album => "Around the Fur",
      :title => "Be Quiet and Drive"}
    assert_equal(query, api.query(metadata))
  end

  def test_05_search_returns_a_hash_of_metadata
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

  def test_06_metadata_hash_contains_song_title
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

  def test_07_metadata_hash_contains_artist_name
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

  def test_08_metadata_hash_contains_album_name
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

  def test_09_metadata_hash_contains_track_number
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

  def test_10_metadata_hash_contains_year
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

  def test_11_metadata_hash_contains_genre
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

  def test_12_search_raises_error_if_status_code_is_no_match
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    metadata = {:title => "a1s2d3f4g5h6j7k8l9"}
    query = api.query(metadata)
    assert_raise(ArgumentError) do
      api.search(query)
    end
  end

  def test_13_search_raises_error_if_status_code_is_error
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    query = "<QUERIES>MISSING DATA<QUERIES>"
    assert_raise(ArgumentError) do
      api.search(query)
    end
  end

end