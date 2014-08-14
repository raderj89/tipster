$ ->
  if $('.js-switch-dd')[0]

    highlightSwitch = (element) ->
      if $(element).hasClass('active')
        $(element).removeClass('active')
      else
        $(element).addClass('active')

    deactivateOtherFields = (otherField, otherSwitch) ->
      if $(otherField).is(':visible')
        $(otherField).slideToggle()
        $(otherSwitch).removeClass('active')

    $('.js-switch-dd').on 'click', ->
      $('.js-direct-deposit').slideToggle()
      highlightSwitch(this)
      deactivateOtherFields('.js-check', '.js-switch-check')

    $('.js-switch-check').on 'click', ->
      $('.js-check').slideToggle()
      highlightSwitch(this)
      deactivateOtherFields('.js-direct-deposit', '.js-switch-dd')