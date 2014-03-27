class User < ActiveRecord::Base
  include PgSearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reservations
  has_many :orders, :foreign_key => :user_id

  validates :email, :uniqueness => true, :presence => true
  validates :name, :presence => true

  pg_search_scope :autocomplete_search,
    against: [:name, :email, :phone],
    using: [ :tsearch, :trigram ],
    ignoring: :accents

  def as_json(options = {})
    {:email => email, :phone => phone, :name => name, :id => id}
  end
end
