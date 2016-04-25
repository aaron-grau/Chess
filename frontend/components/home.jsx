var React = require('react');
var PropTypes = React.PropTypes;
var Board = require('./board');
var ApiUtil = require('../util/api_util');

var Home = React.createClass({

  getInitialState: function () {
    return {turnMessage: "Your Turn!"};
  },

  toggleTurnMessage: function (yourTurn) {
    if (!yourTurn) {
      this.setState({turnMessage: "I'm thinking of the best move..."});
    } else {
      this.setState({turnMessage: "Your Turn!"});
    }
  },

  _restart: function () {
    ApiUtil.fetchNewBoard();
  },

  render: function() {
    return (
      <div className="content">
        <h1>Chess Engine</h1>
        <div className="restart" onClick={this._restart}>Restart Game</div>
        <Board toggleMessage={this.toggleTurnMessage} />
        <div className="turn-message">{this.state.turnMessage}</div>
        <div className="about">
          <span className="about-header">About the engine:<br /></span>
          <ul className="about-list">
          <li>
            ● The engine is written in ruby and is running remotely, everytime you make a move the browser sends an AJAX request to the server for a response move
          </li>
          <li>
            ● The AI applies a minimax algorithm with alpha-beta
            pruning to quickly evaluate over 10 million possible
            future positions per turn
          </li>
          <li>
            ● It uses an evaluation function based off development and piece values to assign point totals to
            positions at the end of each search branch, the values are passed back up the tree and use to assign point values to each current candidate move, the best move is then played
          </li>
          </ul>
        </div>
      </div>
    );
  }

});

module.exports = Home;
