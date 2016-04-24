var React = require('react');
var PropTypes = React.PropTypes;
var Board = require('./board');

var Home = React.createClass({

  render: function() {
    return (
      <Board />
    );
  }

});

module.exports = Home;
