$ ->
  $('.next-is-nested').on 'click', (e) ->
    self = $(this)
    self.closest('.row').next().toggle()

  $('.request-action-title').on 'click', (e) ->
    self = $(this)
    self.next().toggle()

  $('.add-ico, .edit-ico').on 'click', (e) ->
    self = $(this)
    self.closest('.row').toggleClass('is-active')
