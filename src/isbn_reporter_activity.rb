require 'ruboto/widget'
require 'ruboto/util/toast'

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

  private

  def save_isbn
    @text_view.text = 'Will save the info!'
    toast 'Next step is to fetch the info and store it.'
  end

end
