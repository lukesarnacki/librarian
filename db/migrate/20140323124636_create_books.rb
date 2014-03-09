class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string 'title'
      t.string 'author'
      t.text 'details'
      t.timestamps
    end

    add_reference :books, :category
  end
end
