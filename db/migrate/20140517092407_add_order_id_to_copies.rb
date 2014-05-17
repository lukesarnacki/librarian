class AddOrderIdToCopies < ActiveRecord::Migration
  def change
    add_column :copies, :order_id, :integer
  end
end
