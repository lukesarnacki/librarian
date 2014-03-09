require 'csv'

namespace :books do
  desc "import books from csv"
  task :import, [:csv_path] => :environment do |t, args|
    args.with_defaults(csv_path: 'db/books.csv')

    CSV.foreach(Rails.root.join(args[:csv_path]), headers: true) do |row|

      book = Book.where("title = ?", row['title'].strip).first

      book ||= Book.create!(
        title: row['title'].strip,
        author: row['author'].try(:strip),
        details: row['comment'].try(:strip),
        category: Category.find_or_create_by(name: row['category'].strip)
      )

      copy = Copy.where("LOWER(index) = ?", row['index'].downcase.strip).first

      copy ||= book.copies.create!(
        index: row['index'].strip,
        publication: row['year'].try(:strip),
        exists: row['found'].downcase.strip == "tak"
      )

    end
  end
end
