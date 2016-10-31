$ ->
  $('.next-is-nested').on 'click', (e) ->
    self = $(this)
    self.closest('.row').next().toggle()
