class RegisterUserForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :email, String
  attribute :phone, String
  attribute :name, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :email, :name, :password, :password_confirmation, presence: true
  validate :email_uniqueness

  def self.model_name
    ActiveModel::Name.new(self, nil, "RegisterUserForm")
  end

  def persisted?
    false
  end

  def model
    @model ||= User.new
  end

  def save
    if valid?
      @model = RegisterUser.call(attributes)
      true
    else
      false
    end
  end

  def email_uniqueness
    errors[:email] << I18n.t('errors.messages.taken') if User.find_by(email: self.email)
  end
end
