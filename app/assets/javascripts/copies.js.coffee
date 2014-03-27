


#showUserFields = (show) ->
  #if show
    #$('.user-fields').css('display', 'block')
    #$('form#check-out .user-fields input').attr('disabled', false)
  #else
    #$('form#check-out .user-fields input').attr('disabled', true)
    #$('.user-fields').css('display', 'none')
