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

  var margin = {top: 20, right: 40, bottom: 30, left: 40}
  var width = parseInt(d3.select(svg.node().parentNode).style('width')) - margin.left - margin.right;
  var height = parseInt(d3.select(svg.node()).style('height')) - margin.top - margin.bottom;
  var barWidth = width / data.probabilities.length;

  var x = d3.scale.linear()
    .domain(d3.extent(data.probabilities, function(d) { return d }))
    .range([0, width]);

  var y = d3.scale.linear()
    .domain([d3.min(data.quantiles), d3.max(data.quantiles)])
    .range([height, 0])

  var xAxis = d3.svg.axis().scale(x).orient('bottom');
  var yAxis = d3.svg.axis().scale(y).orient('left');

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
    .attr('y', function(d) { return y(d) })
    .attr('width', barWidth - 1)
    .attr('height', function(d) { return height - y(d); })
    .on('mouseover', function(d) { tip.show(d) })
    .on('mouseout', tip.hide);

  chart.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate(0,' + height + ')')
    .call(xAxis);

  chart.append('g')
    .attr('class', 'y axis')
    .attr('transform', 'translate(0, 0)')
    .call(yAxis);
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

  var elHeight = 20;
  var elHeightWitPadding = elHeight + 2;

  svg.selectAll('*').remove();
  var container = d3.select(svg.node().parentNode);

  var margin = {top: 20, right: 40, bottom: 30, left: 20}
  var width = parseInt(container.style('width')) - margin.left - margin.right;
  var height = parseInt(data.length * elHeightWitPadding + 40) - margin.top - margin.bottom;
  var barWidth = width / data.length;

  var x = d3.scale.linear().domain([ startTime, finishTime]).range([startTime, width ]);
  var y = d3.scale.linear().domain([0, data.length]).range([height, 0]);

  var xAxis = d3.svg.axis().scale(x).orient('bottom');

  var parentRect = function(el) {
    var els = data.filter(function(item) {
      return item.started_at < el.started_at && item.finished_at > el.finished_at
    });
    return els.length > 0 ? els[els.length - 1] : el;
  };

  var parentY = function(el) {
    return (parentRect(el).position) * elHeightWitPadding;
  };

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

  var detailsContainer = chart.append('g').attr('class', 'details');
  var rects = detailsContainer.selectAll('g')
    .data(data)
    .enter()
    .append("g").attr('position', function(d) { return d.position })

  rects.append("rect")
    .attr("x", function(d) { return x(timeStartFn(d)) })
    .attr("y", function(d) { return (d.position * elHeightWitPadding) })
    .attr("width", function(d) { return x(d.finished_at - d.started_at) })
    .attr("height", elHeight)
    .attr('class', function(d) { return rectClassFn(d) })
    .attr('data-start', function(d) { return d.started_at })
    .attr('data-finish', function(d) { return d.finished_at })
    .attr('data-duration', function(d) { return d.duration })
  .on('mouseover', function(d) { tip.show(d) })
  .on('mouseout', tip.hide);

  rects.append("rect")
    .attr("x", function(d) { return x(timeStartFn(d)) })
    .attr("y", function(d) { return parentY(d) })
    .attr("width", function(d) { return x(d.finished_at - d.started_at) })
    .attr("height", elHeight)
    .attr('class', function(d) { return rectClassFn(parentRect(d)) + (parentRect(d).position == d.position ? '' : '-child') })
  .on('mouseover', function(d) { tip.show(d) })
  .on('mouseout', tip.hide);

  detailsContainer.call(tip);
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

