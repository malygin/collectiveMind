@visit_chart = ->
  if $('#user_visits_graph').length > 0
    nv.addGraph ->
      chart = nv.models.multiBarChart().stacked(false).showControls(false).margin(
        left: 30
        bottom: 20
        right: 0
      ).color(keyColor).controlsColor([
          $white
          $white
          $white
        ])
      chart.yAxis.showMaxMin(false).ticks(0).tickFormat d3.format("4d")
      chart.xAxis.showMaxMin(false).tickFormat (d) ->
        d3.time.format("%d.%m.%y") new Date(d)

      data = JSON.parse $('#nvd3_project').attr("data-count_people")
      console.log(data)
      d3.select("#user_visits_graph svg").datum(data).transition().duration(500).call chart
      nv.utils.windowResize chart.update
      chart
    nv.addGraph ->
      chart = nv.models.multiBarChart().stacked(false).showControls(false).margin(
        left: 50
        bottom: 20
        right: 0
      ).color(keyColor).controlsColor([
          $white
          $white
          $white
        ])
      chart.yAxis.showMaxMin(false).ticks(0).tickFormat
      chart.xAxis.showMaxMin(false).tickFormat (d) ->
        d3.time.format("%d.%m.%y") new Date(d)
      data = JSON.parse $('#nvd3_project').attr("data-average_time")
      console.log(data)
      d3.select("#average_time_graph svg").datum(data).transition().duration(500).call chart
      nv.utils.windowResize chart.update
      chart
  return
