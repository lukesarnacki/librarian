class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.integer :book_id, :null => false
      t.string  :index, :null => false
      t.string  :publication
      t.integer :state, :default => 0, :null => false
      t.boolean :exists, :null => false, :default => true
      t.timestamps
    end
  end
end
