override_lat = null
override_lng = null

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(getReverseGeocodingData);
  } else {
    $('#refresh-location-img').addClass('hide')
    $('#fetchLatLng').removeClass('hide')
    $('.main-videos').css({ opacity: 1 })
    alert("Sorry, your browser does not support geolocation.")
  }
}


function updateOnServer(position, geocodeString) {
  var lat = override_lat || position.coords.latitude
  var lng = override_lng || position.coords.longitude
  $.ajax({
    url: 'update_location',
    type: 'PUT',
    data: {
      lat: lat,
      lng: lng,
      geo: geocodeString
    },
    success: function(){
      location.reload(true)
    },
    error: function(){
      $('#refresh-location-img').addClass('hide')
      $('#fetchLatLng').removeClass('hide')
      $('.main-videos').css({ opacity: 1 })
      alert("sorry, an error occured on the server")
    }
  })
}

function getReverseGeocodingData(position) {
  var lat = override_lat || position.coords.latitude
  var lng = override_lng || position.coords.longitude
  var latlng = new google.maps.LatLng(lat, lng);
  // This is making the Geocode request
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({ 'latLng': latlng }, function (results, status) {
    if (status !== google.maps.GeocoderStatus.OK) {
      console.log(status);
    }
    // This is checking to see if the Geoeode Status is OK before proceeding
    if (status == google.maps.GeocoderStatus.OK) {
      var match = results.filter(postalMatcher)[0];
      if (match == null) {
        match = results.filter(localityMatcher)[0];
      }
      updateOnServer(position, match.formatted_address)
    }
  });
}

function postalMatcher(x){
  return x.types.includes('postal_code') === true;
}

function localityMatcher(x){
  return x.types.includes('locality') === true;
}

$(function(){
  $('#fetchLatLng').on('click', function(e){
    e.preventDefault()
    $('#refresh-location-img').removeClass('hide')
    if ($(this).hasClass('hide-on-click')){
      $(this).addClass('hide')
    }
    $('.fade-section').fadeTo(400, 0.3)
    getLocation();
  });

  $('#radius').on('change', function(e){
    $('#refresh-location-img').removeClass('hide')

    $.ajax({
      url: 'update_radius',
      type: 'PUT',
      data: {
        radius: $(this).val()
      },
      success: function(){
        location.reload(true)
      },
      error: function(){
        $('#refresh-location-img').addClass('hide')
        $('#fetchLatLng').removeClass('hide')
        $('.main-videos').css({ opacity: 1 })
        alert("sorry, an error occured on the server")
      }
    })
  })
})
