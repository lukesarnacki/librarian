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
      order.check_out
      order
    end
  end
end
