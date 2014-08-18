$ ->
  titleInput = ""
  $title = ""
  currentEmployeeId = $('.all-employees-wrapper').data('current-employee')
  propertyId = $('.my-properties').data('property-id')

  $('.action-link').on 'click', (e) ->
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
    $editLink = $employeeBox.find('.action-link')
    console.log($editLink)
    newTitle = $this.val()
    employeeId = $this.data('prop-employee-id')

    $.ajax({
      url: "/employees/#{currentEmployeeId}/property_employees/#{employeeId}",
      type: "PUT",
      data: { property_employee: { title: newTitle } },
      success: (data) ->
        $this.hide()
        $title.text(newTitle)
        $title.show()
        $editLink.show()
      })

  $moneyField = ""
  $('.right-column').on 'click', 'span', ->
    $this = $(this)

    $column = $this.parent('.right-column')
    $moneyField = $column.find('#suggested_tip')

    $this.hide()

    $moneyField.show()

  $('.right-column').on 'blur', '#suggested_tip', ->
    $this = $(this)
    $column = $this.parent('.right-column')
    $tipText = $column.find('span')
    console.log($tipText)

    newNum = $this.val()
    title = $this.data('title')

    $.ajax({
      url: "/employees/#{currentEmployeeId}/properties/#{propertyId}/update_tips",
      type: "POST"
      data: { title: title, suggested_tip: newNum },
      success: ->
        $this.hide()
        $tipText.text("$#{newNum}")
        $tipText.show()
      })
