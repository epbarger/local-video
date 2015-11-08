function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    $('#refresh-location-img').addClass('hide')
    $('#fetchLatLng').removeClass('hide')
    $('.main-videos').css({ opacity: 1 })
    alert("sorry, geolocation is not supported by this browser")
  }
}

function showPosition(position) {
  $.ajax({
    url: 'update_location',
    type: 'PUT',
    data: {
      lat: position.coords.latitude,
      lng: position.coords.longitude
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

$(function(){
  $('#fetchLatLng').on('click', function(){
    $('#refresh-location-img').removeClass('hide')
    $(this).addClass('hide')
    $('.main-videos').fadeTo(400, 0.3)
    getLocation();
  });
})