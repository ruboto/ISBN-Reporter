require 'ruboto/widget'
require 'ruboto/util/toast'
require 'isbn_information_fetcher'
require 'settings'
require 'storage_proxy'

ruboto_import_widgets :Button, :EditText, :LinearLayout, :ScrollView, :TextView

import android.text.InputType

class IsbnReporterActivity
  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter'

    self.content_view = scroll_view do
      linear_layout do
        linear_layout orientation: :vertical, margins: [5, 5, 5, 5],
            padding: [5, 5, 5, 5], layout: {width: :match_parent} do
          text_view text: 'Store ISBN', text_size: 36, gravity: :center
          text_view text: 'ISBN:'
          @isbn_view = edit_text hint: 'Enter ISBN number',
              input_type: InputType::TYPE_CLASS_PHONE,
              layout: {width: :match_parent}, gravity: :center
          linear_layout do
            button text: 'Save', layout: {width: :match_parent, weight: 1},
                on_click_listener: proc { fetch_isbn }
            button text: 'List', layout: {width: :match_parent, weight: 1},
                on_click_listener: proc { start_ruboto_activity :ListActivity }
          end
          @result_view = text_view
        end
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onResume
    super
    if Settings.api_key.nil?
      toast 'API key is required'
      start_ruboto_activity :SettingsActivity
    end
    @isbn_view.text = ''
    @result_view.text = ''
  end

  def onDestroy
    super
    if @exit_requested
      java.lang.System.runFinalizersOnExit(true)
      java.lang.System.exit(0)
    end
  end

  def onCreateOptionsMenu(menu)
    @settings_button = menu.add('Settings').setOnMenuItemClickListener do
      start_ruboto_activity :SettingsActivity
      true
    end
    @settings_button.show_as_action = android.view.MenuItem::SHOW_AS_ACTION_IF_ROOM

    menu.add('Exit').setOnMenuItemClickListener do
      @exit_requested = true
      finish
      true
    end

    true
  end

  def on_info_received(isbn, info)
    run_on_ui_thread { toast info.inspect; @result_view.text = info.inspect }
    StorageProxy.store(Settings.path, info.update(isbn: isbn))
  end

  def on_error(isbn, error)
    run_on_ui_thread { toast error.inspect; @result_view.text = error.inspect }
    start_ruboto_activity :ManualInputActivity,
        extras: {isbn: isbn, error: error}
  end

  private

  def fetch_isbn
    isbn = @isbn_view.text.to_s
    toast "Fetching info for #{isbn}"
    IsbnInformationFetcher.fetch(self, Settings.api_key, isbn)
  end

end
