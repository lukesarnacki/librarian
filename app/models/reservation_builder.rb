class ReservationBuilder
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute_method_suffix "="
  define_attribute_methods %w[user reservation book]

  attr_reader :attributes
  attr_accessor :params, :auth_type, :user, :authenticated, :flash, :book

  validate :user_presence

  def initialize(current_user, book, auth_type = nil)
    @attributes = {}
    self.user = current_user || User.new
    self.book = book
    self.auth_type = auth_type
    self.prepare_reservation
  end

  def set_auth_type
    self.auth_type = :register if params.delete(:register)
    self.auth_type = :login if params.delete(:login)
  end

  def attributes=(attributes)
    sanitize_for_mass_assignment(attributes).each { |key, value| send("#{key}=", value) }
  end

  def save(params = {})
    self.params = ActionController::Parameters.new(params)
    authenticate_and_build_reservation
    saved = valid? && reservation.save
    send_emails if saved
    saved
  end

  def send_emails
    UserMailer.reservation_created_email(reservation).deliver
    LibrarianMailer.reservation_created_email(reservation).deliver
  end

  def flash
    @flash || I18n.t("flash.actions.create.error")
  end

  def authenticate
    unless %i(register login).include?(auth_type)
      raise ArgumentError, "Auth type has to be passed to new (possible values are :login or :register)"
    end
    self.send(auth_type)
  end

  def login
    self.user = User.find_for_authentication(:email => params[:user][:email])

    if user.nil?
      self.authenticated = false
      self.user = User.new(:email => params[:user][:email])
    else
      self.authenticated = user.valid_password?(params[:user][:password])
    end

    unless authenticated
      self.flash = I18n.t('flash.authentication.email_or_password_invalid')
    end
  end

  def register
    self.user = User.new(params.require(:user).permit(
      :email, :password, :password_confirmation, :remember_me, :name
    ))
    self.authenticated = user.save

    if self.authenticated?
      UserMailer.welcome_email(self.user).deliver
    end
  end

  def authenticate_and_build_reservation
    unless self.authenticated = !self.user.new_record?
      authenticate
    end

    if authenticated?
      build_reservation
    end
  end

  def authenticated?
    self.authenticated
  end

  def prepare_reservation
    self.reservation = book.reservations.build
  end

  def build_reservation
    self.reservation = book.reservations.build(
      params.require(:reservation).permit(:notes)
    )

    self.reservation.user = self.user
  end

  private

  def attribute(attribute)
    @attributes[attribute.to_sym]
  end

  def attribute=(attribute, value)
    @attributes[attribute.to_sym] = value
  end

  def user_presence
    unless user
      errors.add(:user, errors.generate_message(:user, :empty))
    else
      unless authenticated
        errors.add(:user, errors.generate_message(:user, :invalid))
      end
    end
  end
end
