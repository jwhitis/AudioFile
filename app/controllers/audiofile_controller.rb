class AudioFileController
  attr_reader :collection

  def initialize directory
    @collection = Collection.new(directory)
  end

  def execute
  end

end