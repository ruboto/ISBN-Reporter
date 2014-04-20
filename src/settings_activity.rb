require 'storage_proxy'

ruboto_import_widgets :ListView

class SettingsActivity
  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter Settings'

    self.content_view = linear_layout do
      linear_layout orientation: :vertical, margins: [5, 5, 5, 5],
          padding: [5, 5, 5, 5], layout: {width: :match_parent} do
        text_view text: 'Settings', text_size: 36, gravity: :center
        text_view text: 'ISBNdb API Key:'
        @api_key_view = edit_text hint: 'Enter ISBNdb api key',
            layout: {width: :match_parent}, gravity: :center
        text_view text: 'File path:'
        @path_view = edit_text hint: 'books.json',
            layout: {width: :match_parent}, gravity: :center
        button text: 'Save', layout: {width: :match_parent, weight: 1},
            on_click_listener: proc { save_settings }
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onResume
    super
    @api_key_view.text = Settings.api_key
    @path_view.text = Settings.path
  end

  private

  def save_settings
    Settings.api_key = @api_key_view.text.to_s.upcase
    path_value = @path_view.text.to_s
    Settings.path = path_value.empty? ? nil : path_value
    toast 'Settings saved'
    finish
  end

end
