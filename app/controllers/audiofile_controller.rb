class AudioFileController
  attr_reader :collection

  CLIENT_ID = "309248-02139F04093408231C76178AE1A01581"

  def initialize directory
    @collection = Collection.new(directory)
  end

  def new_user?
    User.first.nil?
  end

  def api
    if new_user?
      Gracenote.new(CLIENT_ID)
    else
      Gracenote.new(CLIENT_ID, User.first.gracenote_id)
    end
  end

  def execute
    User.create(gracenote_id: api.user_id) if new_user?
    collection.organize(api)
  end

end