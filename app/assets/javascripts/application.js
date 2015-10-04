//= require jquery
//= require jquery_ujs
//= require bootstrap-material-design
//= require d3
//= require moment

var renderChart = function(token) {
  var from = moment().subtract(7, 'days').format('YYYY-MM-DD');
  var to = moment().format('YYYY-MM-DD');
  var period = 'day';

  var apiEndpoint = '/api/v1/applications/1/sources?api_token=' + token + '&from=' + from + '&to=' + to + '&period=' + period;

  d3.json(apiEndpoint, function(error, json) {
    var data = json.pages;

    var countFn = function(d) { return parseInt(d.count); }
    var parseDate = d3.time.format('%Y-%m-%d %X+00').parse;

    var svg = d3.select('#requests-chart');
    var container = d3.select(svg.node().parentNode);

    var margin = {top: 20, right: 40, bottom: 30, left: 20}
    var width = parseInt(container.style('width')) - margin.left - margin.right;
    var height = parseInt(container.style('height')) - margin.top - margin.bottom;
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
