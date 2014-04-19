require 'ruboto/widget'
require 'ruboto/util/toast'
require 'isbn_information_fetcher'

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

class IsbnReporterActivity
  def onCreate(bundle)
    super
    set_title 'Domo arigato, Mr Ruboto!'

    self.content_view =
        linear_layout :orientation => :vertical do
          text_view text: 'ISBN:'
          @text_view = edit_text :text => '',
              hint: 'Enter ISBN number',
              input_type: android.text.InputType::TYPE_CLASS_NUMBER,
              :layout => {:width => :match_parent},
              :gravity => :center, :text_size => 32.0
          button :text => 'Save',
              :layout => {:width => :match_parent},
              :id => 43, :on_click_listener => proc { save_isbn }
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
    isbn = @text_view.text.to_s
    toast "Fetching info for #{isbn}"
    IsbnInformationFetcher.fetch(self, isbn)
  end

end
