$(function () {

    // Radialize the colors
    Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
        return {
            radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
            stops: [
                [0, color],
                [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
            ]
        };
    });

    // Build the chart
    $('#pie_chart').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Распределение баллов'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    color: '#000000',
                    connectorColor: '#000000',
                    formatter: function() {
                        return '<b>'+ this.point.name +'</b> ';
                    }
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'Распределение баллов',
            data: [
                ['Генерато идей',   parseFloat($('#score_g').html())],
                {
                    name: 'Аналитик',
                    y: parseFloat($('#score_a').html()),
                    sliced: true,
                    selected: true
                },
                ['Оценщик',    parseFloat($('#score_o').html())]

            ]
        }]
    });
});

