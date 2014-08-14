$ ->
  if $('.alert')[0]

    closeAlert = () ->
      $('.alert').slideUp('500')
      
    # Close flash message on click X
    $('.js-close-flash').on 'click', ->
      closeAlert()

    # # Close flash automatically
    setTimeout(closeAlert, 500)
