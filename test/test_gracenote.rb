require "test/unit"
require "./lib/gracenote.rb"

class GracenoteUnitTest < Test::Unit::TestCase

  def test_b1_stores_client_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    assert_equal(client_id, api.client_id)
  end

  def test_b2_stores_user_id
    client_id = "309248-02139F04093408231C76178AE1A01581"
    api = Gracenote.new(client_id)
    assert_equal(client_id, api.client_id)
  end

  def test_b3_url_returns_api_url
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    api = Gracenote.new(client_id)
    assert_equal(url, api.url(client_id))
  end

  def test_b4_query_returns_formatted_xml_query
    client_id = "309248-02139F04093408231C76178AE1A01581"
    user_id = "261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C"
    metadata = {:artist => "The Deftones", :album => "Around the Fur", :title => "Be Quiet and Drive"}
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>The Deftones</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Around the Fur</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Be Quiet and Drive</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    assert_equal(query, api.query(client_id, user_id, metadata))
  end

  def test_b5_search_returns_a_hash_of_metadata
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>The Deftones</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Around the Fur</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Be Quiet and Drive</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal(Hash, metadata.class)
  end

  def test_b6_metadata_hash_contains_song_title
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>At the Drive-In</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Relationship of Command</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Enfilade</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal("Enfilade", metadata[:title])
  end

  def test_b7_metadata_hash_contains_artist_name
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>Dire Straits</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Brothers in Arms</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Walk of Life</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal("Dire Straits", metadata[:artist])
  end

  def test_b8_metadata_hash_contains_album_name
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>The Police</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Synchronicity</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Wrapped Around Your Finger</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal("Synchronicity", metadata[:album])
  end

  def test_b9_metadata_hash_contains_track_number
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>Social Distortion</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Social Distortion</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Story of My Life</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal(3, metadata[:track])
  end

  def test_b10_metadata_hash_contains_year
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>The Wallflowers</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Bringing Down the Horse</TEXT>
        <TEXT TYPE='TRACK_TITLE'>The Difference</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal(1996, metadata[:year])
  end

  def test_b11_metadata_hash_contains_genre
    client_id = "309248-02139F04093408231C76178AE1A01581"
    url = "https://c309248.web.cddbp.net/webapi/xml/1.0/"
    query = "<QUERIES>
      <LANG>eng</LANG>
      <AUTH>
        <CLIENT>309248-02139F04093408231C76178AE1A01581</CLIENT>
        <USER>261861400463019913-67D67C8A2ACA4ED05AF7551A426BBD9C</USER>
      </AUTH>
      <QUERY CMD='ALBUM_SEARCH'>
        <MODE>SINGLE_BEST</MODE>
        <TEXT TYPE='ARTIST'>Tears for Fears</TEXT>
        <TEXT TYPE='ALBUM_TITLE'>Songs From the Big Chair</TEXT>
        <TEXT TYPE='TRACK_TITLE'>Everybody Wants to Rule the World</TEXT>
      </QUERY>
    </QUERIES>"
    api = Gracenote.new(client_id)
    metadata =  api.search(url, query)
    assert_equal("New Romantic", metadata[:genre])
  end

end