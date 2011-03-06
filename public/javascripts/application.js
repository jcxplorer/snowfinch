function updateSiteCounters() {
  $.getJSON($("#counters").data("source"), function(data) {
    var visitsCounter = $(".counter[data-counter=visits] .value"),
        pageviewsCounter = $(".counter[data-counter=pageviews] .value"),
        visitorsCounter = $(".counter[data-counter=visitors] .value");

    visitsCounter.text(data.active_visits);
    pageviewsCounter.text(data.pageviews_today);
    visitorsCounter.text(data.visitors_today);
  });
}

jQuery(function() {
  if ($("#counters[data-source]").length) {
    updateSiteCounters();
    setInterval(updateSiteCounters, 1000);
  }
});
