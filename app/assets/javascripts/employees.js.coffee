$ ->
  titleInput = ""
  $title = ""
  currentEmployeeId = $('.all-employees-wrapper').data('current-employee')
  propertyId = $('.my-properties').data('property-id')

  $('.single-employee .js-action-link').on 'click', (e) ->
    e.preventDefault()

    $this = $(this)
    $this.hide()
    $employeeBox = $this.parent('.single-employee')
    propEmployeeId = $this.data('prop-employee-id')
    $title = $employeeBox.find("p[data-prop-employee-id=#{propEmployeeId}]")
    titleInput = $employeeBox.find("#titles[data-prop-employee-id='#{propEmployeeId}']")
    $title.hide()
    titleInput.show()
  
  $('.single-employee').on 'change', '#titles', ->
    $this = $(this)
    $employeeBox = $this.parents('.single-employee')
    $editLink = $employeeBox.find('.js-action-link')
    console.log($editLink)
    newTitle = $this.val()
    employeeId = $this.data('prop-employee-id')

    $.ajax "/employees/#{currentEmployeeId}/property_employees/#{employeeId}",
      type: "PUT",
      data: { property_employee: { title: newTitle } },
      success: (data) ->
        $this.hide()
        $title.text(newTitle)
        $title.show()
        $editLink.show()

  $moneyField = ""
  $row = ""
  $('.js-edit-column').on 'click', '.js-action-link', (e) ->
    e.preventDefault()

    $this = $(this)
    $this.addClass('js-active')
    $this.text("save")
    $row = $this.parents('tr')
    $tipText = $row.find('.right-column span')
    $moneyField = $row.find('#suggested_tip')

    $tipText.hide()
    $moneyField.show()


  $('.js-edit-column').on 'click', '.js-active', (e) ->
    e.preventDefault()

    $this = $(this)
    $this.removeClass('js-active')
    newNum = $row.find('#suggested_tip').val()
    title = $moneyField.data('title')
    $tipText = $row.find('.right-column span')

    $.ajax "/employees/#{currentEmployeeId}/properties/#{propertyId}/update_tips",
      type: "POST"
      data: { title: title, suggested_tip: newNum },
      success: ->
        $this.text("edit")
        $moneyField.hide()
        $tipText.text("$#{newNum}")
        $tipText.show()

  $('.single-property .js-action-link').on 'click', (e) ->
    e.preventDefault()

    $('.js-edit-photo').show()

  # $('.single-property').on 'change', '#picture:file', ->
  #   console.log(this);
  #   filename = this.files[0].name
  #   subFilename = filename.substring(0, 12)

  #   $.ajax "/employees/#{currentEmployeeId}/properties/#{propertyId}"
  #     type: "PUT"
  #     data: { property: { picture: }}
  #   # Add ellipses if name is too long
  #   if subFilename.length > 12
  #     subFilename = subFilename + '...'

  #   # Appends filename to page
  #   $(this).prev().html(subFilename)
    