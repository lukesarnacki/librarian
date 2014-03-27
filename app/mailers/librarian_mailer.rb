class LibrarianMailer < ActionMailer::Base
  default from: "biblioteka@skg.uw.edu.pl"
  layout 'email'

  def reservation_created_email(reservation)
    @reservation = reservation
    @user = reservation.user
    @book = reservation.book
    mail(to: 'biblioteka@skg.uw.edu.pl', subject: t('librarian_mailer.reservation_created_email.subject'))
  end
end
