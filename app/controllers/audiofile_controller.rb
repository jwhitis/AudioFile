class AudioFileController
  attr_reader :collection

  CLIENT_ID = "309248-02139F04093408231C76178AE1A01581"

  def initialize directory
    @collection = Collection.new(directory)
  end

  def execute
    if User.first.nil?
      api = Gracenote.new(CLIENT_ID)
      User.create(gracenote_id: api.user_id)
    else
      api = Gracenote.new(CLIENT_ID, User.first.gracenote_id)
    end
    collection.organize(api)
  end

end