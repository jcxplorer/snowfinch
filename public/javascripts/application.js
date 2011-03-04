function updateSiteCounters() {
  $.getJSON($("#counters").data("source"), function(data) {
    var dayCounter = $(".counter[data-period=today] .value"),
        weekCounter = $(".counter[data-period=week] .value"),
        monthCounter = $(".counter[data-period=month] .value");

    dayCounter.text(data.day);
    weekCounter.text(data.week);
    monthCounter.text(data.month);
  });
}

$.fn.flashText = function(color) {
  var originalColor = this.css("color")
  this.animate({ color: color }, 150, function() {
    $(this).animate({ color: originalColor }, 150);
  });
}

jQuery(function() {
  if ($("#counters[data-source]").length) {
    updateSiteCounters();
    setInterval(updateSiteCounters, 1000);
  }
});
