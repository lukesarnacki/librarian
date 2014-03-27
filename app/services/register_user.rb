class RegisterUser
  def self.call(attributes)
    User.transaction do
      user = User.create!(
        name: attributes[:name],
        email: attributes[:email],
        phone: attributes[:phone],
        password: attributes[:password],
        password_confirmation: attributes[:password_confirmation]
      )
      user
    end
  end
end
