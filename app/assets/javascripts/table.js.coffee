$ ->
  $('.next-is-nested').on 'click', (e) ->
    self = $(this)
    self.closest('.row').next().toggle()

  $('.request-action-title').on 'click', (e) ->
    self = $(this)
    self.next().toggle()
