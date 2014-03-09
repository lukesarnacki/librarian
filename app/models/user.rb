class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reservations
  has_many :orders, :foreign_key => :user_id

  validates :email, :uniqueness => true, :presence => true
  validates :name, :presence => true

  def self.search(q)
    v = "%#{q.downcase}%"
    where([" LOWER(name) LIKE ? OR phone LIKE ? OR LOWER(email) LIKE ?", v, v, v])
  end

  def as_json(options = {})
    {:email => email, :phone => phone, :name => name, :id => id}
  end
end
