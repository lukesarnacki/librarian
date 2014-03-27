class ReservationsController < ApplicationController

  respond_to :html, :js
  before_filter :set_auth_type, only: [:create]

  def index
    @book = Book.find(params[:book_id])
    @reservations = @book.reservations
    render :index, layout: !request.xhr?
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @book = @reservation.book
    @reservation.destroy
  end

  def create
    @book = Book.find(params[:book_id])
    @just_signed_in = false
    @reservation_builder = ReservationBuilder.new(current_user, @book, @auth_type)

    unless @reservation_builder.save(params[:reservation_builder])
      flash_message(:error, @reservation_builder.flash)
    else
      @just_signed_in = true
      sign_in(@reservation_builder.user)
    end

    @reservation = @reservation_builder.reservation

    respond_with @reservation_builder, :layout => !request.xhr?
  end

  private
  def set_auth_type
    @auth_type = :register if params[:register]
    @auth_type = :login if params[:login]
  end
end
