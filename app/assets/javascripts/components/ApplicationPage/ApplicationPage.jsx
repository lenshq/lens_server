var ApplicationPage = React.createClass({

  formSubmited: function(state) {
    console.log("Submited", state);
    var that = this;

    var params = {
      date_from: state.dateFrom,
      date_to: state.dateTo,
      id: state.appId
    };

    var url = "/applications/1/query?" + $.param(params);

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