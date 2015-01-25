@visit_chart = ->
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

    data = get_data()
    console.log data
    d3.select("#user_visits_graph svg").datum(data).transition().duration(500).call chart
    nv.utils.windowResize chart.update
    chart

  return

get_data = ->
  project_id = $('#nvd3_project').attr("data-project")
  if project_id
    jqXHR = $.ajax(
      url: "/project/#{project_id}/project_users/analytics"
      type: "get"
      dataType: "json"
      async: false
    );
    return jqXHR.responseJSON;
