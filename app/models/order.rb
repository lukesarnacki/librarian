class Order < ActiveRecord::Base
  belongs_to :copy
  belongs_to :user
  belongs_to :anonymous_user, :foreign_key => :user_id

  before_destroy :auto_check_in

  validates_presence_of :to, :on => :update
  validates :from, :presence => true

  def check_in(params)
    if self.update_attributes(:to => params[:to])
      checked_in = copy.check_in
    end
    checked_in
  end

  def to
    super || Date.today
  end

  private

  def auto_check_in
    copy.check_in if copy.last_order == self
  end
end
