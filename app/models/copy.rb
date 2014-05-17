class Copy < ActiveRecord::Base
  belongs_to :book, inverse_of: :copies
  has_many :reservations, :through => :book
  has_many :orders
  belongs_to :order
  validates :index, :presence => true

  delegate :title, :author, :details, :category, :to => :book

  def self.borrowed
    where("order_id IS NOT NULL")
  end

  def self.available
    where("order_id IS NULL")
  end

  def self.found_in_collection
    where(found_in_collection: true)
  end

  def check_in
    update_attribute(:order_id, nil)
  end

  def check_out(order)
    update_attribute(:order_id, order.id)
  end

  def overdue?
    order && order.overdue?
  end
end
