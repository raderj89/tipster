$ ->
  titleInput = ""
  $title = ""
  currentEmployeeId = $('.all-employees-wrapper').data('current-employee')

  # Pulses text green
  showSuccess = (container) ->
    container.addClass('change-success')
    changeBack = ->
      container.removeClass('change-success')
    setTimeout changeBack, 500
  
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
    showSuccess($employeeBox)

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
        showSuccess($row)
        $this.text("edit")
        $moneyField.hide()
        $tipText.text("$#{newNum}")
        $tipText.show()

  $('.single-property .js-action-link').on 'click', (e) ->
    e.preventDefault()

    $('.js-edit-photo').show()
    
  $('.js-cancel-edit').on 'click', ->
    $('.js-edit-photo').hide()
