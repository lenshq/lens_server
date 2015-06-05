var FilterForm = React.createClass({

  handleChange: function(e) {
    var state = {};
    state[e.target.name] = e.target.value;
    this.setState(state);
  },

  getInitialState: function() {
    var appsIds = [
      {id: 1, name: "App ID #1"}
    ];

    var weekAgo = new Date()
    weekAgo.setDate(weekAgo.getDate() - 7);

    today = new Date(Date.now());
    weekAgo = new Date(weekAgo);

    today = [today.getFullYear(), today.getMonth(), today.getDay()];
    weekAgo = [weekAgo.getFullYear(), weekAgo.getMonth(), weekAgo.getDay()];

    var dates = [today, weekAgo];

    for(var i in dates) {
      dates[i] = dates[i].map(function(e){
        console.log("e is", e);
        e = e.toString()
        if(e.length < 2) {
          console.log("Remap")
          e = "0" + e;
        };

        return e;
      });
    }

    return {
      dateFrom: dates[1].join("-"),
      dateTo : dates[0].join("-"),
      urlFilter: "",
      appsIds: appsIds,
      appId: 1
    }
  },

  submited: function() {
    this.props.onSubmit(this.state);
    return false;
  },

  render: function() {
    return (
      <form className="filter-form" onSubmit={this.submited}>
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
