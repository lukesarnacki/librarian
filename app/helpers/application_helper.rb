module ApplicationHelper

  def available_copies(book)
    copies(book)
  end

  def unavailable_copies(book)
    copies(book, false)
  end

  def copies_count(book)
    "#{book.available_copies_count} / #{book.copies_count}"
  end

  def reservations_count(book)
    book.reservations.count
  end

  def borrowed_count(book)
    book.copies.borrowed.count
  end

  def reserved_html_class(book)
    book.reserved?.to_s
  end

  def book_class(book)
    'reserved' if book.reserved?
  end

  def filter_class(params, filter)
    'active' if params[:filter].to_s == filter.to_s || (filter == :all && params[:filter].blank?)
  end

  private

  def copies(book, available = true)
    html_class = if available
                   'available btn btn-success btn-xs check-out btn-copy'
                 else
                   'unavailable btn btn-xs check-in btn-copy'
                 end

    scope = book.copies.found_in_collection
    scope = available ? scope.available : scope.borrowed

    scope.map do |c|
      unless available
        html_class += c.overdue? ? ' btn-danger' : ' btn-warning'
      end
      options = { id: c.id }
      path = available ? available_copy_path(c) : borrowed_copy_path(c)
      link_to c.index, path,
        class: html_class,
        data: { toggle: :modal, target: '#mainModal', backdrop: 'static',
                keyboard: false, remote: path }

    end.join.html_safe
  end
end
