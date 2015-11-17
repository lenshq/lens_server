var renderTreeChart = function(app, source, scenario, token) {
  var apiEndpoint = '/api/v1/applications/' + app + '/sources/' + source + '/scenarios/' + scenario + '?api_token=' + token;

  d3.json(apiEndpoint, function(error, json) {
    var data = json.events.sort(function(a, b) { return a.started_at - b.started_at});

    var rectClassFn = function(d) { return d.event_type.replace(/\./g, '-') };

    var startFn = function(d) { return d.started_at };
    var finishFn = function(d) { return d.finished_at };

    var startTime = d3.min(data, startFn);
    var finishTime = d3.max(data, finishFn);

    var timeStartFn = function(d) { return d.started_at - startTime };
    var timeFinishFn = function(d) { return d.finished_at - startTime };

    var svg = d3.select('#events-chart');
    var container = d3.select(svg.node().parentNode);

    var margin = {top: 20, right: 40, bottom: 30, left: 20}
    var width = parseInt(container.style('width')) - margin.left - margin.right;
    var height = parseInt(data.length * 20 + 40) - margin.top - margin.bottom;
    var barWidth = width / data.length;

    var x = d3.scale.linear().domain([ startTime, finishTime]).range([startTime, width ]);
    var y = d3.scale.linear().domain([0, data.length]).range([height, 0])

    var xAxis = d3.svg.axis().scale(x).orient('bottom');

    var chart = svg
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

    var tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .direction('e')
      .html(function(d) {
        return '<div class="tooltip">' +
            '<strong>Content:</strong>' + '<br />' +
            '<span>' + (d.content == null ? d.event_type : d.content) + '</span>' + '<br/>' +
            '<strong>Duration:</strong>' + '<br />' +
            '<span>' + d.duration.toFixed(2) + 'ms</span>' + '<br/>' +
          '</div>';
      });


    var globalTimeContainer = chart.append('g').attr('class', 'global-time');
    var detailsContainer = chart.append('g').attr('class', 'details');

    detailsContainer.call(tip);

    globalTimeContainer.selectAll('rect')
      .data(data)
      .enter()
      .append("rect")
        .attr("x", function(d) { return x(timeStartFn(d)) })
        .attr("y", function(d) { return 0 })
        .attr("width", function(d) { return x(d.finished_at - d.started_at) })
        .attr("height", 20)
        .attr('class', function(d) { return rectClassFn(d) });


    detailsContainer.selectAll('rect')
    .data(data.slice(1))
    .enter()
    .append("rect")
      .attr("x", function(d) { return x(timeStartFn(d)) })
      .attr("y", function(d) { return (d.position * 20) + 10})
      .attr("width", function(d) { return x(d.duration) })
      .attr("height", 20)
      .attr('class', function(d) { return rectClassFn(d) })
      .attr('data-start', function(d) { return d.started_at })
      .attr('data-finish', function(d) { return d.finished_at })
      .attr('data-duration', function(d) { return d.duration })
    .on('mouseover', function(d) { tip.show(d) })
    .on('mouseout', tip.hide);
  });
}
