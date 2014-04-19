require 'storage_proxy'

ruboto_import_widgets :ListView

class ListActivity
  def onCreate(bundle)
    super
    set_title 'ISBN Information Reporter'

    self.content_view = linear_layout do
      linear_layout orientation: :vertical, margins: [5, 5, 5, 5],
          padding: [5, 5, 5, 5], layout: {width: :match_parent} do
        @list_view = list_view list: []
      end
    end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def onResume
    super
    Thread.start do
      begin
        items = StorageProxy.load
        run_on_ui_thread do
          begin
            @list_view.adapter.add_all items
          rescue Exception
            puts "Exception adding items: #{$!}"
            puts $!.backtrace.join("\n")
          end
        end
      rescue Exception
        puts "Exception showing items: #{$!}"
        puts $!.backtrace.join("\n")
      end
    end
  end

  private

  def save_isbn
    api_key = @api_key_view.text.to_s
    isbn = @isbn_view.text.to_s
    toast "Fetching info for #{isbn}"
    IsbnInformationFetcher.fetch(self, api_key, isbn)
  end

end
