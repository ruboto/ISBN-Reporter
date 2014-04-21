require 'json'

class StorageProxy
  def self.store(path, entry)
    puts "Storing: #{path.inspect}: #{JSON.dump(load(path) + [entry])}"
    File.write(path, JSON.dump(load(path) + [entry]))
  end

  def self.load(path)
    if File.exists? path
      JSON.parse File.read(path)
    else
      []
    end
  end

end
