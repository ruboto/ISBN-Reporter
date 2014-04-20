class Settings
  SETTINGS_FILE = 'settings.json'
  API_KEY = 'api_key'
  PATH_KEY = 'path'

  def self.api_key
    load[API_KEY]
  end

  def self.api_key=(value)
    value = nil if value.strip.empty?
    save load.update(API_KEY => value)
  end

  def self.path
    load[PATH_KEY] || 'books.json'
  end

  def self.path=(value)
    value = nil if value.strip.empty?
    save load.update(PATH_KEY => value)
  end

  private

  def self.load
    if File.exists?(SETTINGS_FILE)
      JSON.parse File.read(SETTINGS_FILE)
    else
      {}
    end
  end

  def self.save(settings)
    File.write(SETTINGS_FILE, JSON.dump(settings))
  end
end
