require 'ruboto/widget'
require 'ruboto/util/toast'
require 'isbn_information_fetcher'

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

class IsbnReporterActivity
  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter'

    self.content_view =
        linear_layout orientation: :vertical do
          text_view text: 'ISBNdb API Key:', text_size: 32.0
          @api_key_view = edit_text text: 'MyAccCode', text_size: 32.0,
              hint: 'Enter ISBNdb api key',
              input_type: android.text.InputType::TYPE_CLASS_NUMBER,
              layout: {:width => :match_parent}, gravity: :center
          text_view text: 'ISBN:', text_size: 32.0
          @isbn_view = edit_text text_size: 32.0,
              hint: 'Enter ISBN number',
              input_type: android.text.InputType::TYPE_CLASS_NUMBER,
              layout: {width: :match_parent}, gravity: :center
          button text: 'Save', layout: {width: :match_parent},
              id: 43, on_click_listener: proc { save_isbn }
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def on_information_received(info)
    run_on_uithread { toast info.inspect }
  end

  def on_error(error)
    run_on_ui_thread { toast error.inspect }
  end

  private

  def save_isbn
    api_key = @api_key_view.text.to_s
    isbn = @isbn_view.text.to_s
    toast "Fetching info for #{isbn}"
    IsbnInformationFetcher.fetch(self, api_key, isbn)
  end

end
