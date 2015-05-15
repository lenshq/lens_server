var StartPageUnlogged = React.createClass({
  render: function() {
    return (
      <div className="jumbotron">
        <div className="container">
          <h1>I think your app is very slow...</h1>
          <p>Sing up via your GitHub account to prove that i'm wrong</p>
          <a href={this.props.url} className="btn btn-large btn-success">Sign in</a>
        </div>
      </div>
    );
  }
})
