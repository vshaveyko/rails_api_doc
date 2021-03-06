_header_height = 0
_window_height = 0
_window = null
_side_menu = null

$ ->
  $('.next-is-nested').on 'click', (e) ->
    self = $(this)
    self.closest('.row').next().toggleClass('is-shown')

  $('.request-action-title').on 'click', (e) ->
    self = $(this)
    next = self.next()
    return unless next.hasClass('flex-table')
    next.toggle()

  $('.flex-table input, .flex-table select').on 'click', (e) ->
    e.stopPropagation()

  $('span.ico').on 'click', (e) ->
    self = $(this)
    e.preventDefault()
    e.stopPropagation()
    self.closest('.row').toggleClass('is-active')

  $('.destroy').on 'click', (e) ->
    self = $(this)

    self.closest('.flex-line').toggleClass('destroyed')

  $('form.flex-line').on 'submit', () ->
    $(this).addClass('updated')
    $(this).removeClass('is-active')

  # _header_height = $('.aside').offset().top

  _window = $(window)

  _window_height = _window.height()

  _side_menu = $('#side-menu')

$(document).on 'scroll', ->
  _scrollTop = _window.scrollTop()

  if _scrollTop > _header_height
    _side_menu.addClass('fixed')
  else
    _side_menu.removeClass('fixed')

  $("#side-menu li").removeClass('is-current')

  $("#side-menu li a").each () ->
    self = $(this)

    _attached_block_id = self.attr('href')
    # 0 is '#'
    _attached_block = document.getElementById(_attached_block_id.substring(1))
    jq_block = $(_attached_block)

    # 5 is magic number to get block in sight on top get selected in menu
    offset_top =  jq_block.offset().top - 5
    offset_height = jq_block.height()

    if _scrollTop > offset_top && _scrollTop < offset_top + offset_height
      self.closest('li').addClass('is-current')
