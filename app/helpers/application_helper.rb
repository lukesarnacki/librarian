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

  private

  def copies(book, available = true)
    html_class = if available
                   'available btn btn-success btn-xs check-out btn-copy'
                 else
                   'unavailable btn btn-danger btn-xs check-in btn-copy'
                 end

    scope = book.copies
    scope = available ? scope.available : scope.borrowed

    scope.map do |c|
      options = { id: c.id }
      path = copy_path(options)
      link_to c.index, path,
        class: html_class,
        data: { toggle: :modal, target: '#mainModal', backdrop: 'static',
                keyboard: false, remote: path }

    end.join.html_safe
  end
end
