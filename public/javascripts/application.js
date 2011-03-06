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

function plotChart() {
  $.getJSON($("#chart").data("source"), function(data) {
    $.plot("#chart", [
           { data: data.yesterday },
           { data: data.today }
    ],
    {
      lines: { show: true, fill: true },
      points: { show: true },
      colors: ["#ccc", "#d18b2c"],
      yaxis: { min: 0, tickDecimals: 0 },
      xaxis: { tickSize: 2, tickFormatter: function(number) {
        if (number == 0) {
          return "";
        }
        else if (number < 10) {
          return "0" + number + ":00";
        }
        else {
          return number + ":00";
        };
      } }
    });
  });
}

jQuery(function() {
  if ($("#counters[data-source]").length) {
    updateSiteCounters();
    setInterval(updateSiteCounters, 1000);
  }

  if ($("#chart[data-source]").length) {
    plotChart();
    setInterval(plotChart, 1000);
  }
});
