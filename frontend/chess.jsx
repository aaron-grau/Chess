var React = require('react');
var ReactDOM = require('react-dom');
var ReactRouter = require('react-router');
var Router = ReactRouter.Router;
var Route = ReactRouter.Route;
var IndexRoute = ReactRouter.IndexRoute;
var browserHistory = ReactRouter.browserHistory;
var Home = require('./components/home');

var App = React.createClass({

  render: function () {
    return (
      <div id="chess-app">
        {this.props.children}
      </div>
    )
  }

});

var router = (
 <Router history={browserHistory}>
   <Route path="/" component={App}>
     <IndexRoute component={Home}/>
   </Route>
 </Router>
);

$(function () {
  ReactDOM.render(router, $('#root')[0]);
});
