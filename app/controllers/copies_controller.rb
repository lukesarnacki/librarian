class CopiesController < ApplicationController

  respond_to :html, :js
  load_and_authorize_resource except: [:check_in]
  before_filter :load_book, :only => [:new, :edit, :create, :update]

  def available
    @copy = Copy.find(params[:id])
    @check_out = CheckOutForm.new
    @book = @copy.book
    @reservations = @copy.reservations
    @show_user_fields = @reservations.empty?
    respond_with @copy, :layout => !request.xhr?
  end

  def borrowed
    @copy = Copy.find(params[:id])
    @order = @copy.order
    @order.to = Time.zone.today
    load_objects
    respond_with @copy, :layout => !request.xhr?
  end

  def check_out
    @copy = Copy.find(params[:id])
    @check_out = CheckOutForm.new(params[:check_out])
    @book = @copy.book
    @reservations = @copy.reservations

    unless @check_out.save
      @new_user_chosen = @check_out.user_id.blank?
      flash_message(:error, t("flash.actions.create.error"))
    end

    respond_with @check_out, :location => request.xhr? ? check_out_copy_path(@copy) : books_path, :layout => !request.xhr?
  end

  def check_in
    @order = Order.find(params[:id])
    @copy = @order.copy
    @order.check_in(params[:order].permit(:to))

    unless @order.valid?
      flash_message(:error, t("flash.actions.create.error"))
    end

    respond_with @order, :location => request.xhr? ? check_in_copy_path(@copy) : books_path, :layout => !request.xhr?
  end

  def new
    respond_with @copy, :layout => !request.xhr?
  end

  def create
    unless @copy.save
      flash_message(:error, t("flash.actions.create.error"))
    end

    respond_with @copy, :location => edit_book_path(@book), :layout => !request.xhr?
  end

  def edit
    respond_with @copy, :layout => !request.xhr?
  end

  def update
    unless @copy.update_attributes(params[:copy])
      flash_message(:error, t("flash.actions.create.error"))
    end

    respond_with @copy, :location => edit_book_path(@book), :layout => !request.xhr?
  end

  def destroy
    @copy = Copy.find(params[:id])
    @book = @copy.book
    @copy.destroy

    respond_to do |format|
      format.html { redirect_to(edit_book_path(@book)) }
      format.xml  { head :ok }
    end
  end

  private

  def load_book
    @book = Book.find(params[:book_id])
  end

  def load_objects
    @copy = @order.copy
    @book = @copy.book
    @reservations = @copy.reservations
    @show_user_fields = @reservations.empty?
  end
end
