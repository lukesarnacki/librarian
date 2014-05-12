class BooksController < ApplicationController

  load_and_authorize_resource
  before_filter :get_objects
  respond_to :html

  def index
    @q = Search.new(params[:q])
    @books = Book.only_with_copies.search(@q)
    @books = @books.select('distinct books.*')
                   .order('title ASC').page params[:page]
    @categories = Category.scoped

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  def reserve
    @book = Book.find(params[:id])
    @reservation_builder = ReservationBuilder.new(current_user, @book)
    @reservation = @reservation_builder.reservation
    @user = @reservation_builder.user

    respond_with @book, :layout => !request.xhr?
  end

  private

  def get_objects
    @categories = Category.order('name ASC')
  end
end
