require 'ruboto/widget'
require 'ruboto/util/toast'
require 'isbn_information_fetcher'
require 'storage_proxy'

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

import android.text.InputType

class IsbnReporterActivity
  API_KEY_FILE = 'api_key'

  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter'

    self.content_view = linear_layout do
      linear_layout orientation: :vertical, margins: [5, 5, 5, 5],
          padding: [5, 5, 5, 5], layout: {width: :match_parent} do
        text_view text: 'ISBNdb API Key:'
        @api_key_view = edit_text hint: 'Enter ISBNdb api key',
            layout: {:width => :match_parent}, gravity: :center
        text_view text: 'ISBN:'
        @isbn_view = edit_text hint: 'Enter ISBN number',
            input_type: InputType::TYPE_CLASS_PHONE,
            layout: {width: :match_parent}, gravity: :center
        linear_layout do
          button text: 'Save', layout: {width: :match_parent, weight: 1},
              on_click_listener: proc { save_isbn }
          button text: 'List', layout: {width: :match_parent, weight: 1},
              on_click_listener: proc { start_ruboto_activity :ListActivity }
        end
        @result_view = text_view
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onResume
    super
    if File.exists?(API_KEY_FILE)
      api_key = File.read(API_KEY_FILE)
      run_on_ui_thread do
        @api_key_view.text = api_key
        @isbn_view.request_focus
      end
    else
      run_on_ui_thread { @api_key_view.request_focus }
    end
  end

  def on_info_received(info)
    run_on_ui_thread { toast info.inspect; @result_view.text = info.inspect }
    StorageProxy.store(info)
  end

  def on_error(error)
    run_on_ui_thread { toast error.inspect; @result_view.text = error.inspect }
  end

  private

  def save_isbn
    api_key = @api_key_view.text.to_s.upcase
    File.write(API_KEY_FILE, api_key)
    isbn = @isbn_view.text.to_s
    toast "Fetching info for #{isbn}"
    IsbnInformationFetcher.fetch(self, api_key, isbn)
  end

end
