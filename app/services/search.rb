class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :title, :category_id

  def initialize(attrs)
    attrs ||= {}
    self.title = attrs[:title]
    self.category_id = attrs[:category_id]
  end

  def persisted?
    false
  end
end
