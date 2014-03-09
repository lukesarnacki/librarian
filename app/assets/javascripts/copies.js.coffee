$ ->
  $(document).bind 'shown.bs.modal', ->
    autocompleteUserName()
    prepareDatepicker()
    showUserFields( $('.reservation').length == 0 )

  $('#check-out').on 'click', '.remove-user', ->
    $('.user-data').html('')
    showUserFields( true )
    false

  $(document).on 'change', '.order_user_id', ->
    showUserFields( false )
    false

  $(document).on 'change','#order_user_id_nil', ->
    showUserFields( true )
    false

  $(document).on 'click', 'button#remove-autocompleted-user', ->
    button = $(this)
    button.addClass('hidden')
    $('#autocompleted-user-id').val('').attr('disabled', true)
    $('#user-name').val('').attr('disabled', false)
    $('#user-email').val('').attr('disabled', false)
    $('#user-phone').val('').attr('disabled', false)


  $(document).on 'typeahead:selected', '#user-name', (event, suggestion, dataset ) ->
    $('button#remove-autocompleted-user').removeClass('hidden')
    $('#autocompleted-user-id').val(suggestion.id).attr('disabled', false)
    $('#user-name').attr('disabled', true)
    $('#user-email').val(suggestion.email).attr('disabled', true)
    $('#user-phone').val(suggestion.phone).attr('disabled', true)

  showUserFields = (show) ->
    if show
      $('.user-fields').css('display', 'block')
      $('form#check-out .user-fields input').attr('disabled', false)
    else
      $('form#check-out .user-fields input').attr('disabled', true)
      $('.user-fields').css('display', 'none')

  autocompleteUserName = ->
    users = new Bloodhound
      name: "titles"
      prefetch:
        url: '/users.json'
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace d.name
      queryTokenizer: Bloodhound.tokenizers.whitespace

    users.initialize()

    $("#user-name").typeahead
      highlight: true
    ,
      name: "users"
      source: users.ttAdapter()
      displayKey: "name"
      templates:
        suggestion: Handlebars.compile([
          "<p class=\"repo-language\">{{name}}</p>"
          "<p class=\"repo-name\">{{email}}</p>"
          "<p class=\"repo-description\">{{phone}}</p>"
        ].join(""))

  prepareDatepicker = ->
    $("input.calendar").datepicker
      format: "dd/mm/yyyy"
      todayBtn: "linked"
      language: "pl"
      autoclose: true
      todayHighlight: true
