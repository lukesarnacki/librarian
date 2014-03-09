$ ->
  $('#mainModal').on 'hidden.bs.modal', (e) ->
    $(this).removeData('bs.modal');
