jQuery(function() {

  if ($("#pulse[data-source]").length) {
    var path = $("#pulse").attr("data-source");
    var last_pageviews;

    $.getJSON(path, function(data) {
      var chart = new Highcharts.Chart({
        chart: { renderTo: "pulse", type: "spline" },
        title: { text: "Pulse" },
        legend: { enabled: false },
        plotOptions: { spline: { lineWidth: 1, shadow: false } },
        xAxis: { type: "datetime" },
        yAxis: { title: null, allowDecimals: false, startOnTick: false, minPadding: 0.1 },
        series: [{ data: [] }],
        credits: { enabled: false }
      });

      setInterval(function() {
        $.getJSON(path, function(data) {
          var move = chart.series[0].data.length > 9,
              pageviews = data.pageviews[data.pageviews.length-1],
              time = Math.floor((new Date).getTime()/1000) * 1000,
              diff = 0;

          if (pageviews > last_pageviews) { diff = pageviews - last_pageviews; }
          if (pageviews < last_pageviews) { diff = pageviews; }

          chart.series[0].addPoint([time, diff], true, move);
          last_pageviews = pageviews;
        });
      }, 1000);
    });
  }

  function addPulse(chart) {
    var time = new Date().getTime();
    chart.series[0].addPoint([time, Math.random()]);
  }

  if ($("#pageviews[data-source]").length) {
    $.getJSON($("#pageviews").attr("data-source"), function(data) {
      var chart = new Highcharts.Chart({
        chart: { renderTo: "pageviews", defaultSeriesType: "spline" },
        plotOptions: { series: { animation: false }, spline: { lineWidth: 3 } },
        title: { text: "Pageviews and Visits" },
        xAxis: { categories: data.hours, tickInterval: 2, tickWidth: 0 },
        yAxis: { title: null, min: 0 },
        legend: { enabled: false },
        tooltip: { shared: true, crosshairs: true },
        series: [
          { name: "Pageviews", data: data.pageviews },
          { name: "Visits", data: data.visits }
        ],
        credits: { enabled: false }
      });

      setTimeout(function() {
        chart.series[0].setData([1,2,3,4,5,6,10,6,4,4,2,4]);
        chart.series[1].setData([2,3,4,5,6,7,6,4,3,2,4,3]);
      }, 5000);
    });
  }

});
