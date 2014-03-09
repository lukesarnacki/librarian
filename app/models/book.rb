class Book < ActiveRecord::Base
  include PgSearch

  belongs_to :category
  has_many :copies
  has_many :reservations
  validates :title, :category_id, :presence => true
  accepts_nested_attributes_for :copies

  after_save :remove_copies_without_book

  pg_search_scope :search_title,
    against: [:title],
    using: [ :tsearch, :trigram ],
    ignoring: :accents

  def orders_count
    self.copies.available - self.orders.count
  end

  def self.search(query)
    results = self.scoped
    results = search_title(query.title) if query.title.present?
    results = results.where(category_id: query.category_id) if query.category_id.present?
    results
  end

  def available_copies_count
    c = self.copies.available.count - self.reservations.count
    c <= 0 ? 0 : c
  end

  def no_available_copies?
    available_copies_count == 0
  end

  def copies_count
    self.copies.count
  end

  def reserved_for?(user)
    self.reservations.where(:user_id => user).present?
  end

  def reserved?
    self.reservations.present?
  end

  def available?
    available_copies_count > 0
  end

  private

  def remove_copies_without_book
    Copy.where(:book_id => nil).destroy_all
  end
end
