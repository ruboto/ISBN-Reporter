require 'json'

class StorageProxy
  FILE_NAME = 'items.json'

  def self.store(info)
    File.write(FILE_NAME, JSON.dump(load + [info]))
  end

  def self.load
    if File.exists? FILE_NAME
      JSON.parse File.read(FILE_NAME)
    else
      []
    end
  end

end
