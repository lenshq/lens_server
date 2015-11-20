var renderTreeHistogram = function(data, element) {
  var countFn = function(d) { return d; }

  var svg = d3.select(element);

  svg.selectAll('*').remove();

  var tip = d3.tip()
    .attr('class', 'd3-tip')
    .direction('n')
    .html(function(d) {
      return '<div class="histogram-tooltip">' + d + '</div>';
    });

  var margin = {top: 20, right: 40, bottom: 30, left: 20}
  var width = parseInt(d3.select(svg.node().parentNode).style('width')) - margin.left - margin.right;
  var height = parseInt(d3.select(svg.node()).style('height')) - margin.top - margin.bottom;
  var barWidth = width / data.probabilities.length;

  var x = d3.scale.linear()
    .domain(d3.extent(data.probabilities, function(d) { return d }))
    .range([barWidth / 2, width - barWidth / 2]);

  var y = d3.scale.linear()
    .domain([d3.min(data.quantiles), d3.max(data.quantiles)])
    .range([height, 0])

  var xAxis = d3.svg.axis().scale(x).orient('bottom');

  var chart = svg
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
    .append('g')
      .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

  chart.call(tip);

  var bar = chart.selectAll('g')
    .data(data.quantiles)
  .enter().append('g')
    .attr('transform', function(d, i) { return 'translate(' + i * barWidth + ', 0)'; });

  bar.append('rect')
    .attr('class', 'bar')
    .attr('y', function(d) { console.log(d); return y(d) })
    .attr('width', barWidth - 1)
    .attr('height', function(d) { return height - y(d); })
    .on('mouseover', function(d) { tip.show(d) })
    .on('mouseout', tip.hide);

  chart.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate(0,' + height + ')')
    .call(xAxis);
};


var renderTreeChart = function(data) {
  var rectClassFn = function(d) { return d.event_type.replace(/\./g, '-') };

  var startFn = function(d) { return d.started_at };
  var finishFn = function(d) { return d.finished_at };

  var startTime = d3.min(data, startFn);
  var finishTime = d3.max(data, finishFn);

  var timeStartFn = function(d) { return d.started_at - startTime };
  var timeFinishFn = function(d) { return d.finished_at - startTime };

  var svg = d3.select('#events-chart');

  svg.selectAll('*').remove();
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
    .attr("width", function(d) { return x(d.finished_at - d.started_at) })
    .attr("height", 20)
    .attr('class', function(d) { return rectClassFn(d) })
    .attr('data-start', function(d) { return d.started_at })
    .attr('data-finish', function(d) { return d.finished_at })
    .attr('data-duration', function(d) { return d.duration })
  .on('mouseover', function(d) { tip.show(d) })
  .on('mouseout', tip.hide);
};

var renderScenariosChart = function(app, source, scenario, token) {
  var apiEndpoint = '/api/v1/applications/' + app + '/sources/' + source + '/scenarios/' + scenario + '?api_token=' + token;

  d3.json(apiEndpoint, function(error, json) {
    var treeData = json.events.sort(function(a, b) { return a.started_at - b.started_at});
    var histogramData = json.quantiles;
    var distributionData = json.distributions;

    renderTreeHistogram(histogramData, '#quantiles-chart');
    renderTreeHistogram(distributionData, '#distribution-chart');
    renderTreeChart(treeData);
  });
}
