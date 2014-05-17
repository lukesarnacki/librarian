class Order < ActiveRecord::Base
  belongs_to :copy
  belongs_to :user
  belongs_to :anonymous_user, foreign_key: :user_id

  before_destroy :auto_check_in

  validates :from, presence: true
  validates :to, presence: true, on: :update

  state_machine :state, :initial => :checked_out do
    event :return do
      transition :checked_out => :checked_in
    end

    state :checked_out
    state :checked_in
  end

  def check_in(params)
    if self.update_attributes(to: params[:to])
      checked_in = copy.check_in
    end
    checked_in
  end

  def check_out
    copy.check_out(self)
    copy.reservations.where(:user_id => self.user).destroy_all
  end

  def self.ongoing
    where(state: :checked_out)
  end

  def overdue?
    due < Time.zone.today
  end

  private

  def auto_check_in
    copy.check_in if copy.order = self
  end
end
