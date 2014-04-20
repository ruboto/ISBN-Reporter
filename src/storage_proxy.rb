require 'json'

class StorageProxy
  def self.store(path, info)
    puts "Storing: #{path.inspect}: #{JSON.dump(load(path) + [info])}"
    File.write(path, JSON.dump(load(path) + [info]))
  end

  def self.load(path)
    if File.exists? path
      JSON.parse File.read(path)
    else
      []
    end
  end

end
