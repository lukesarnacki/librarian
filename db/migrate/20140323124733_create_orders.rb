class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date    :from, null: false
      t.date    :to
      t.date    :due
      t.integer :copy_id, null: false
      t.integer :user_id, null: false
      t.string  :notes

      t.timestamps
    end
  end
end
