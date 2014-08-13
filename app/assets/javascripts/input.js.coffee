$ ->
  if $('.js-pretty-input')[0]

    # Trigger click event on real input when pretty one is clicked
    $('.js-pretty-input').on 'click', (e) ->
      e.preventDefault()
      $(this).next().find('input').click()  

    # Append filename on page if file is selected
    $(':file').on 'change', ->
      filename = this.files[0].name
      subFilename = filename.substring(0, 12)

      # Add ellipses if name is too long
      if subFilename.length > 12
        subFilename = subFilename + '...'

      # Appends filename to page
      $('.js-pretty-input').html(subFilename);
      