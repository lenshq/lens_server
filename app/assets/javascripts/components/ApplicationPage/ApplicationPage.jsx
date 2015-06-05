var ApplicationPage = React.createClass({

  formSubmited: function(e) {
    return false;
  },

  render: function() {
    return (
      <div className="row">
        <FilterForm onSubmit={this.formSubmited} />
      </div>
    );
  }

})