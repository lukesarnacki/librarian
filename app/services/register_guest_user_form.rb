class RegisterGuestUserForm < RegisterUserForm
  def initialize(*attrs)
    self.password = SecureRandom.hex
    self.password_confirmation = self.password
    super
  end

  def save
    if valid?
      @model = RegisterGuestUser.call(attributes)
      true
    else
      false
    end
  end
end
