class CheckOut
  def self.call(attributes)
    Order.transaction do
      order = Order.create!(
        from: attributes[:from],
        due: attributes[:due],
        copy_id: attributes[:copy_id],
        user_id: attributes[:user_id],
        notes: attributes[:notes]
      )
      order.copy.check_out
      order.copy.reservations.where(:user_id => order.user).destroy_all
      order
    end
  end
end
