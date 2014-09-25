$ ->
  $('#admin_property_search').autocomplete
    source: $('#admin_property_search').data('autocomplete-source')
    minLength: 5
    select: (event, ui) ->
      $('#invitation_property_id').val(ui.item.id)
  .autocomplete("instance")._renderItem = (ul, item) ->
    item.value = item.full_address
    item.label = item.full_address
    $("<li>")
      .attr('data-value', item.value)
      .append("<img src='" + item.picture_thumb + "'>" + item.label)
      .appendTo(ul)