require 'open-uri'
require 'json'
require 'pp'
require 'ruboto/util/stack'

# This is for ISBNdb API V2
class IsbnInformationFetcher
  def self.fetch(activity, api_key, isbn)
    isbn.gsub!(/[^0-9]/, '')

    Thread.with_large_stack do
      begin
        begin
          content = open("http://isbndb.com/api/v2/json/#{api_key}/book/#{isbn}").read
        rescue Exception
          puts "Exception opening ISBN info URL: #{$!}"
          puts $!.backtrace.join("\n")
          activity.on_error $!.to_s
          next
        end

        obj = JSON.parse(content)

        if obj.size == 2
          activity.on_info_received title: obj['data'][0]['title'],
              longtitle: obj['data'][0]['longtitle'],
              author: obj['data'][0]['author'],
              publisher: obj['data'][0]['publisher'],
              summary: obj['data'][0]['summary'],
              notes: obj['data'][0]['notes'],
              urls: obj['data'][0]['urls'],
              awards: obj['data'][0]['awards']
        else
          activity.on_error obj['error']
        end
      rescue Exception
        puts "Exception fetching ISBN info: #{$!}"
        puts $!.backtrace.join("\n")
        activity.on_error $!.to_s
      end
    end
  end
end
