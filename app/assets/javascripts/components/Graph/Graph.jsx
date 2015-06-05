var Graph = React.createClass({

  getInitialState: function() {
    return {
      graphData: []
    }
  },

  componentWillReceiveProps: function(nextProps) {
    var that = this;

    if(nextProps["graph-data"]) {
      this.setState({graphData: nextProps["graph-data"]});
    }

  },

  componentDidUpdate: function(prevProps, prevState) {
    if(prevState["graphData"]) {
      this.drawChart();
    }
  },

  drawChart: function() {
    if(this.state.graphData.length == 0) { return false; }

    var test = this.state.graphData;

    var formated = [
      ['Ms', 'Group size']
    ];

    for(var i in test) {
      var el = test[i];
      formated.push(
        [
          el.range.join("-"),
          el.count
        ]
      );
    };

    var data = new google.visualization.DataTable();
    var data = new google.visualization.arrayToDataTable(formated);

    var options = {
      title: '',
      hAxis: {
        title: 'Duration',
        format: '',
        viewWindow: {
          min: [7, 30, 0],
          max: [17, 30, 0]
        }
      },
      vAxis: {
        title: 'Cunt'
      }
    };

    var chart = new google.visualization.ColumnChart(
      React.findDOMNode(this));

    chart.draw(data, options);
  },

  componentDidMount: function() {
    google.load('visualization', '1', {
      packages: ['corechart', 'bar'],
      callback: function() {}
    });
    google.setOnLoadCallback(this.drawChart);

    return true;
  },

  render: function() {
    return (
      <div id="chartDiv"></div>
    );
  }

});

