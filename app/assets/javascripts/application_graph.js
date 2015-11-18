var renderTable = function(app, eventSources) {
  var totalTime = d3.sum(eventSources, function(d) { return d.time });
  var totalDuration = d3.sum(eventSources, function(d) { return d.duration });
  var totalCount = d3.sum(eventSources, function(d) { return d.count });

  var medianTime = d3.median(eventSources, function(d) { return d.time });
  var medianDuration = d3.median(eventSources, function(d) { return d.duration });
  var medianCount = d3.median(eventSources, function(d) { return d.count });

  var tableValues = function(d) { return [d[0], [d[0], d[1]], d[2], d[3], d[4]] };

  var tdClassName = function(i) { return (i == 0 || i == 1) ? 'left' : 'right' }
  var linkOrDataFn = function(i, e) {
    switch(i) {
        case 1:
            return '<a href="/applications/' + app + '/sources/' + e[0] +'">' + e[1] + '</a>';
            break;
        case 2:
            return (e > medianDuration) ? '<strong>' + e + '</strong>' : e;
            break;
        case 3:
            return (e > medianTime) ? '<strong>' + e + '</strong>' : e;
            break;
        case 4:
            return (e > medianCount) ? '<strong>' + e + '</strong>' : e;
            break;
        default:
            return e;
    }
  };

  var tableLabelFn = function(key) {
    switch(key) {
     case 'id':
         return '#';
         break;
     case 'path':
         return 'Controller#action';
         break;
     case 'duration':
         return 'Response time (avg)';
         break;
     case 'time':
         return 'Response time (sum)';
         break;
     case 'count':
         return 'Requests count';
         break;
    };
  };

  d3.select('#event-sources thead')
    .selectAll('th')
    .data(d3.keys(eventSources[0]))
    .enter()
    .append('th')
    .text(function(d) { return tableLabelFn(d); })
    .attr('class', function(d, i) { return tdClassName(i); });

  var tr = d3.select('#event-sources tbody')
    .selectAll('tr')
    .data(eventSources)
    .enter()
    .append('tr');

  tr.selectAll('td')
    .data(function(d) { return tableValues(d3.values(d)); })
    .enter()
    .append('td')
    .html(function(d, i) {
      return linkOrDataFn(i, d);
    })
    .attr('class', function(d, i) { return tdClassName(i); });
};

var renderChart = function(app, token) {
  var apiEndpoint = '/api/v1/applications/' + app + '/sources?api_token=' + token;

  d3.json(apiEndpoint, function(error, json) {
    renderTable(app, json.event_sources);

    var data = json.requests;

    var countFn = function(d) { return parseInt(d.count); }
    var parseDate = d3.time.format('%Y-%m-%d %X+00').parse;

    var svg = d3.select('#requests-chart');
    // var container = d3.select(svg.node().parentNode);

    var margin = {top: 20, right: 40, bottom: 30, left: 20}
    var width = parseInt(d3.select(svg.node().parentNode).style('width')) - margin.left - margin.right;
    var height = parseInt(d3.select(svg.node()).style('height')) - margin.top - margin.bottom;
    var barWidth = width / data.length;

    var x = d3.time.scale()
      .domain([
        parseDate(data[0].date),
        parseDate(data[data.length - 1].date)
      ])
      .range([barWidth / 2, width - barWidth / 2]);
    var y = d3.scale.linear()
      .domain([0, d3.max(data, countFn)])
      .range([height, 0])

    var xAxis = d3.svg.axis().scale(x).orient('bottom');

    var chart = svg
        .attr('width', width + margin.left + margin.right)
        .attr('height', height + margin.top + margin.bottom)
      .append('g')
        .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

    var bar = chart.selectAll('g')
      .data(data)
    .enter().append('g')
      .attr('transform', function(d, i) { return 'translate(' + i * barWidth + ', 0)'; });

    bar.append('rect')
      .attr('class', 'bar')
      .attr('y', function(d) { return y(d.count) })
      .attr('width', barWidth - 1)
      .attr('height', function(d) { return height - y(d.count); });

    chart.append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')')
      .call(xAxis);
  });
}
