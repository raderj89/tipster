$ ->
  # Tipping subtotal update
  if $('.tipping-wrapper')[0]

    # Get all number-inputs
    $numberInputs = $('input[type=text]')

    $numberInputs.on 'keyup', ->
      tipValues = []
      subtotal = 0

      # Get values of all inputs and push into  tipValues if is a number
      $.each($numberInputs, (i) ->
        singleValue = parseInt($($numberInputs[i]).val())

        if singleValue >= 0
          tipValues.push(singleValue)
        )

      # Add all entered tips
      for value in tipValues
        subtotal += value

      # Display subtotal on page
      $('.js-subtotal').html("$#{subtotal}")