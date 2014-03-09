class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super do |resource|
      UserMailer.welcome_email(resource).deliver
    end
  end
end
