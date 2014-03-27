class UserMailer < ActionMailer::Base
  default from: "biblioteka@skg.uw.edu.pl"
  layout 'email'

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: t('user_mailer.welcome_email.subject'))
  end

  def guest_registered_email(user)
    @user = user
    mail(to: user.email, subject: t('user_mailer.guest_registered_email.subject'))
  end

  def reservation_created_email(reservation)
    @reservation = reservation
    @user = reservation.user
    @book = reservation.book
    mail(to: @user.email, subject: t('user_mailer.reservation_created_email.subject'))
  end
end
