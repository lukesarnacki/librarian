$.fn.spin = (path) ->
  path = path || "spinner.gif"
  return this.each ->
    element = $(this)
    element.after('<img src="/images/'+path+'" class="spinner"/>')

$.fn.stopSpin = ->
  return this.each ->
    element = $(this)
    element.next().remove()
