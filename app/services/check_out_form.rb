class CheckOutForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :from, DateTime
  attribute :due, DateTime
  attribute :notes, String
  attribute :copy_id, Integer
  attribute :user_id, Integer

  validates :from, :due, :copy_id, :user_id, presence: true

  attr_writer :register_user_form

  def persisted?
    false
  end

  def from
    super || Date.today
  end

  def due
    super || Date.today + 1.month
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "CheckOut")
  end

  def register_user_form
    @register_user_form ||= RegisterGuestUserForm.new
  end

  def model
    @model ||= Order.new
  end

  def initialize(attributes = {})
    user_attributes = attributes.delete(:register_user_form)
    self.register_user_form.attributes = user_attributes if user_attributes
    super
  end

  def save
    if self.user_id.blank?
      self.register_user_form.save
      self.user_id = register_user_form.model.id
    end

    if valid?
      @model = CheckOut.call(attributes)
      true
    else
      false
    end
  end
end
