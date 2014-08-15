$ ->

  closeAlert = () ->
    $('.alert').slideUp('500')
    
  # Close flash message on click X
  $('body').on 'click', '.js-close-flash', ->
    closeAlert()

  # # Close flash automatically
  setInterval(closeAlert, 3000)
