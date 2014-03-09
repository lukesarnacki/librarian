class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id, null: false
      t.integer :book_id, null: false
      t.string :notes

      t.timestamps
    end

    add_index :reservations, :user_id
    add_index :reservations, :book_id
  end
end
