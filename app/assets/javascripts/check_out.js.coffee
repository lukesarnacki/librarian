window.Librarian.classes.CheckOut = class CheckOut

  constructor: ->
    @initialize()

  initialize: ->
    @initializeModal()

  toggleUserForm: (toggle) ->
    @userForm.toggle(toggle)
    $('input', @userForm).attr('disabled', !toggle)

  initializeUserForm: ->
    self = this
    @toggleUserForm( $('#guest_user_id').is(':checked') or $('.reservation').length == 0 )

    $(document).on 'click', '.reservations-radio-buttons input', (e) ->
      self.toggleUserForm( $(this).attr('id') == 'guest_user_id' )

    $(document).on 'click', 'button#remove-autocompleted-user', ->
      button = $(this)
      button.addClass('hidden')
      $('#autocompleted-user-id').val('').attr('disabled', true)
      $('.order-guest-user-name.string').removeClass('input-group')
      $('#guest_user_id').val('')
      $('#user-name').val('').attr('disabled', false)
      $('#user-email').val('').attr('disabled', false)
      $('#user-phone').val('').attr('disabled', false)

    $(document).on 'typeahead:selected', '#user-name', (event, suggestion, dataset ) ->
      $('button#remove-autocompleted-user').removeClass('hidden')
      $('#autocompleted-user-id').val(suggestion.id).attr('disabled', false)
      $('.order-guest-user-name.string').addClass('input-group')
      $('#user-name').val(suggestion.name).attr('disabled', true)
      $('#user-email').val(suggestion.email).attr('disabled', true)
      $('#user-phone').val(suggestion.phone).attr('disabled', true)

  initializeForm: ->
    self = this
    $(document).on 'CheckOut.failure', ->
      $('.alert-message').alert();
      self.onModalShow()

    $(document).on 'CheckOut.success', ->
      $('#mainModal').modal('hide')

  initializeModal: ->
    self = this
    $(document).bind 'shown.bs.modal', ->
      self.onModalShow()

  onModalShow: ->
    @form = $('form#check-out')
    @userForm = $('.user-fields', self.form)

    @initializeUsersAutocomplete()
    @initializeDatepicker()
    @initializeUserForm()
    @initializeForm()

  initializeUsersAutocomplete: ->
    users = new Bloodhound
      name: "titles"
      prefetch:
        url: '/users.json'
      remote:
        url: '/users.json?autocomplete=%QUERY'
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

  initializeDatepicker: ->
    $("input.calendar").datepicker
      format: "dd/mm/yyyy"
      todayBtn: "linked"
      language: "pl"
      autoclose: true
      todayHighlight: true

