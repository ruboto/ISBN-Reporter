class StorageProxy
# 0   id         | integer                     | not null default nextval('books_id_seq'::regclass)
# 1   isbn       | character varying(255)      |
# 2   title      | character varying(255)      |
# 3   longtitle  | character varying(255)      |
# 4   author     | character varying(255)      |
# 5   publisher  | character varying(255)      |
# 6   summary    | text                        |
# 7   notes      | text                        |
# 8   urls       | character varying(255)      |
# 9   awards     | character varying(255)      |
# 10  borrowed   | boolean                     |
# 11  created_at | timestamp without time zone | not null
# 12  updated_at | timestamp without time zone | not null

  def self.store(info)
# Currently just saving data to a text file

    fout = File.open('tbookjson.sql', 'a')

    fout.puts "INSERT INTO books (
isbn,
title,
longtitle,
author,
publisher,
summary,
notes,
urls,
awards,
borrowed,
borrower,
created_at,
updated_at
)
VALUES ("

    fout.printf "'#{isbn}', "
    fout.printf "'#{title}', "
    fout.printf "'#{longtitle}', "
    fout.printf "'#{author}', "
    fout.printf "'#{publisher}', "
    fout.printf "'#{summary}', "
    fout.printf "'#{notes}', "
    fout.printf "'#{urls}', "
    fout.printf "'#{awards}', "
    fout.printf "FALSE, "
    fout.printf "'', "
    fout.printf "now(), "
    fout.printf "now()"
    fout.puts ") ;"
    fout.puts ""

    fout.close

# Need to send the data to the PG server instead

    conn = PGconn.connect("10.1.1.10", 5432, '', '', "books", "phil", "")
    res = conn.exec('select * from books ;')

    res.each do |row|
      row.each do |column|
        puts row
      end
    end

  end
end
