function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    alert("Geolocation is not supported by this browser.")
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
      console.log('error updating lat lng')
    }
  })
}

$(function(){
  $('#fetchLatLng').on('click', function(){
    getLocation();
  });
})