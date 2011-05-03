function updateSiteCounters() {
  $.getJSON($("#counters").data("source"), function(data) {
    var activeVisitors = $(".counter[data-counter=active_visitors] .value"),
        pageviewsToday = $(".counter[data-counter=pageviews_today] .value"),
        visitorsToday = $(".counter[data-counter=visitors_today] .value");

    activeVisitors.text(data.active_visitors);
    pageviewsToday.text(data.pageviews_today);
    visitorsToday.text(data.visitors_today);

    setTimeout(updateSiteCounters, 1000);
  });
}

function createChart() {
  var options = {
        lines: { "show": true, "fill": true },
        points: { "show": true },
        colors: ["#ccc", "#d18b2c"],
        yaxis: { min: 0, tickDecimals: 0 },
        xaxis: { tickSize: 2, tickFormatter: function(number) {
          if (number == 0) { return ""; }
          else if (number < 10) { return "0" + number + ":00"; }
          else { return number + ":00"; }
        } }
      },
      data = [],
      chart = $.plot("#chart", data, options);

  updateChart(chart);
}

function updateChart(chart) {
  console.log(chart);
  $.getJSON($("#chart").data("source"), function(data) {
    chart.setData([data.yesterday, data.today]);
    chart.setupGrid();
    chart.draw();
    setTimeout(updateChart, 1000, chart);
  });
}

jQuery(function() {
  if ($("#counters[data-source]").length) {
    updateSiteCounters();
  }

  if ($("#chart[data-source]").length) {
    createChart();
  }

  $("#add_host_link").click(function(event) {
    var div = $("<div/>").addClass("input referrer"),
        ts = new Date().getTime(),
        label = $("<label/>", {
                  "for": "sensor_hosts_attributes_" + ts + "_host"
                }).html("Referrer host"),
        input = $("<input/>", {
                  "id": "sensor_hosts_attributes_" + ts + "_host",
                  "maxlength": 255,
                  "name": "sensor[hosts_attributes][" + ts + "][host]",
                  "size": 50,
                  "type": "text"
                }),
        remove = $('<a href="#" class="remove">remove<a/>');

    label.appendTo(div);
    input.appendTo(div);
    remove.appendTo(div);

    div.appendTo("#sensor_referrers");

    event.preventDefault();
  });

  if ($("#query_sensor_form").length + $("#referrer_sensor_form").length > 1) {
    $("#referrer_sensor_form").hide();
  }

  $("#query_based_toggle").click(function(event) {
    $("#query_sensor_form").show();
    $("#referrer_sensor_form").hide();
    $(this).addClass("active");
    $(this).siblings().removeClass("active");
    event.preventDefault();
  });

  $("#referrer_based_toggle").click(function(event) {
    $("#referrer_sensor_form").show();
    $("#query_sensor_form").hide();
    $(this).addClass("active");
    $(this).siblings().removeClass("active");
    event.preventDefault();
  });

  $("#sensor_referrers .referrer a.remove").live("click", function(event) {
    $(this).parent().remove();
    event.preventDefault();
  });
});
