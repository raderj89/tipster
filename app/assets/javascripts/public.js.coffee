$ ->
  # jQuery UI autocomplete
  $('#property_search').autocomplete
    appendTo: '#property_listings'
    # Source to fetch data
    source: $('#property_search').data('autocomplete-source')
    # Minimum length entered until we start querying the server
    minLength: 5
    # Function to execute upon list opening
    # This is where I append the no-property button
    open: (event, ui) ->
      unless $('.no-prop-button').is(':visible')
        $('.ui-autocomplete').after("<div class='no-prop-button'>" +
                                     "<a href='#'>Don't see your property?" +
                                     " Invite your property manager to SmartyTip</div>")
    # Function to execute upon list closing
    # Remove the no-property button
    close: (event, ui) ->
      $('.no-prop-button').remove();
  # Custom rendering on autocomplete instance
  # used to append property images to the list
  .autocomplete("instance")._renderItem = (ul, item) ->
    $("<li>")
      .append("<img src='" + item.picture_url + "'>" + item.full_address)
      .appendTo(ul)