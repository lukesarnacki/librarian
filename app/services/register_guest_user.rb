class RegisterGuestUser < RegisterUser
  def self.call(attributes)
    user = super
    # UserMailer.guest_registered_email(user).deliver
    user
  end
end

