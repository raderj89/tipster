$ ->
  # Tipping subtotal update
  if $('.tipping-wrapper')[0]

    # Get all number-inputs
    $numberInputs = $('input[type=text]')

    $numberInputs.on 'keyup', ->
      tipValues = []
      subtotal = 0

      $.each($numberInputs, (i) ->
        singleValue = parseInt($($numberInputs[i]).val())
        if singleValue >= 0
          tipValues.push(singleValue)
        )

      for value in tipValues
        subtotal += value

      $('.js-subtotal').html("$#{subtotal}")