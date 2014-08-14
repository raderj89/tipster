$ ->
  $('.js-switch-dd').on 'click', ->
    $('.js-direct-deposit').slideToggle()
    $(this).addClass('active')

    if $('.js-check').is(':visible')
      $('.js-check').slideToggle()
      $('.js-switch-check').removeClass('active')

  $('.js-switch-check').on 'click', ->
    $('.js-check').slideToggle()
    $(this).addClass('active')

    if $('.js-direct-deposit').is(':visible')
      $('.js-direct-deposit').slideToggle()
      $('.js-switch-dd').removeClass('active')