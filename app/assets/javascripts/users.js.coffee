window.property_partial = (item) ->
  '<div class="js-property-relation">' +
      '<img alt="Apartments" src="' + item.picture_thumb + '">' + '<div class="property-info">' +
      '<p>' + item.full_address + '</p>' + '<div class="input hidden user_property_relations_property_id">' +
      '<input class="hidden" id="user_property_relations_attributes_' + item.id + 
      '_property_id" name="user[property_relations_attributes][' + item.id +
      '][property_id]" type="hidden" value="' + item.id + '"></div>' +
      '<div class="input string required user_property_relations_unit">'+
      '<label class="string required control-label" for="user_property_relations_attributes_' + item.id + '_unit">'+
      '<input class="string required" id="user_property_relations_attributes_' + item.id + '_unit" name="user[property_relations_attributes][' + item.id + '][unit]" type="text" placeholder="Unit #">' +
      '</div></div><a class="js-remove-building" href="#">remove</a>' +  
  '</div>'

$ ->
  $('form').on 'click', '.js-remove-building', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.closest('.js-property-relation').remove()

  $('.js-add-building').on 'click', (e) ->
    e.preventDefault()
    $('#js-building-search').show()
    $('#js-property-search').val('')

  $('#js-property-search').autocomplete
    appendTo: '#js-property-listings'
    source: $('#js-property-search').data('autocomplete-source')
    minLength: 5
    open: (event, ui) ->
      unless $('#js-property-search').val().length > 0
        $('#js-property-search').val('')
    close: (event, ui) ->
      inputField = $('#js-property-search')
      $('.js-no-prop-button').remove()
    select: (event, ui) ->
      $('.js-property-relation:last-child').after(property_partial(ui.item))
      $('#js-building-search').hide()
      $('.ui-autocomplete').children().remove()
  .autocomplete("instance")._renderItem = (ul, item) ->
    item.value = item.full_address
    item.label = item.full_address
    $("<li>")
      .attr('data-value', item.value)
      .append("<img src='" + item.picture_thumb + "'>" + item.label +
              "<a href='#' class='js-property-select'>Select</a>")
      .appendTo(ul)
  
  $('#js-property-search-user-show').autocomplete
    appendTo: '#js-property-listings'
    source: $('#js-property-search-user-show').data('autocomplete-source')
    minLength: 5
    open: (event, ui) ->
      unless $('#js-property-search-user-show').val().length > 0
        $('#js-property-search').val('')
    close: (event, ui) ->
      inputField = $('#js-property-search')
      $('.js-no-prop-button').remove()
    select: (event, ui) ->
      $('.all-properties-wrapper').after(property_partial(ui.item))
      $('#js-building-search').hide()
      $('.ui-autocomplete').children().remove()
  .autocomplete("instance")._renderItem = (ul, item) ->
    item.value = item.full_address
    item.label = item.full_address
    $("<li>")
      .attr('data-value', item.value)
      .append("<img src='" + item.picture_thumb + "'>" + item.label +
              "<a href='#' class='js-property-select'>Select</a>")
      .appendTo(ul)
  