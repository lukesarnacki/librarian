$ ->
  $(document).on 'click', '.loading', ->
    btn = $(this)
    btn.button('loading')
