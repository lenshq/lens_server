var FilterForm = React.createClass({

  handleChange: function(e) {
    var state = {};
    state[e.target.name] = e.target.value;
    this.setState(state);
  },

  getInitialState: function() {
    var appsIds = [
      {id: 1, name: "App ID #1"},
      {id: 2, name: "App ID #2"},
      {id: 3, name: "App ID #3"}
    ];

    return {
      dateFrom: "1988-01-07",
      dateTo :"2015-01-07",
      urlFilter: "",
      appsIds: appsIds,
      appId: appsIds[0].id
    }
  },

  submited: function() {
    this.props.onSubmit(this.state);
    return false;
  },

  render: function() {
    return (
      <form onSubmit={this.submited}>
        <div className="col-md-6">
          <div className="form-group">
            <label htmlFor="appIdSelect">App ID</label>
            <select name="appId" className="form-control" id="appIdSelect" value={this.state.appId} onChange={this.handleChange}>
              {
                this.state.appsIds.map(function(val){
                  return <option value={val.id}>{val.name}</option>
                })
              }
            </select>
          </div>
          <div className="form-group">
            <label htmlFor="durationInput">Duration</label>
            <input id="duration" type="range"></input>
          </div>
          <div className="form-group">
            <label htmlFor="dateFromInput">Date from</label>
            <input name="dateFrom" className="form-control" type="date" value={this.state.dateFrom} onChange={this.handleChange}></input>
          </div>
          <div className="form-group">
            <label htmlFor="dateToInput">Date to</label>
            <input name="dateTo" className="form-control" type="date" value={this.state.dateTo} onChange={this.handleChange}></input>
          </div>
          <div className="form-group">
            <label htmlFor="urlFilterInput">Url filter:</label>
            <input name="urlFilter" className="form-control" value={this.state.urlFilter} onChange={this.handleChange}></input>
          </div>
          <div className="form-group">
            <button className="btn btn-primary" type="submit">Go!</button>
          </div>
        </div>
      </form>
    );
  }
});