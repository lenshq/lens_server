var ApplicationPage = React.createClass({

  formSubmited: function(state) {
    console.log("Submited", state);
    var that = this;

    var url = "/applications/1/query?date_from=";
    url += state.dateFrom;
    url += "&date_to=";
    url += state.dateTo;

    $.ajax(
      url,
      {
        success: function(e) {
          console.log("Success", e);

          window.checkMe = e;
          that.setState({graphData: e})
        }
      }
    )
    return false;
  },

  getInitialState: function() {
    return {
      graphData: []
    }
  },

  render: function() {
    return (
      <div>
        <div className="row">
          <FilterForm onSubmit={this.formSubmited} />
        </div>
        <Graph graph-data={this.state.graphData} />
      </div>
    );
  }

})