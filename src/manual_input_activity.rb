require 'storage_proxy'

ruboto_import_widgets :ListView, :ScrollView

class ManualInputActivity
  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter Settings'

    isbn = intent.get_extra('isbn')
    error = intent.get_extra('error')

    self.content_view = scroll_view do
      linear_layout do
        linear_layout orientation: :vertical, margins: [5, 5, 5, 5],
            padding: [5, 5, 5, 5], layout: {width: :match_parent} do
          text_view text: 'ISBN lookup failed:', text_size: 30,
              gravity: :center
          text_view text: error, gravity: :center

          text_view text: 'Manual input:', text_size: 36, gravity: :center

          @input_views = [
              [:isbn, 'ISBN'], [:title, 'Title'], [:longtitle, 'Longtitle'], [:author, 'Author'],
              [:publisher, 'Publisher'], [:summary, 'Summary'], [:notes, 'Notes'],
              [:urls, 'URLs'], [:awards, 'Awards'],
          ].map do |field, title|
            text_view text: title
            edit_text hint: "Enter #{title.downcase}", tag: field,
                layout: {width: :match_parent}, gravity: :center
          end
          @input_views[0].text = isbn
        end
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onCreateOptionsMenu(menu)
    @settings_button = menu.add('Save').setOnMenuItemClickListener do
      save_entry
      true
    end
    @settings_button.show_as_action = android.view.MenuItem::SHOW_AS_ACTION_IF_ROOM
    true
  end

  private

  def save_entry
    StorageProxy.store(Settings.path, Hash[@input_views.map { |v| [v.tag, v.text.to_s] }])
    toast 'ISBN entry saved'
    finish
  end

end
