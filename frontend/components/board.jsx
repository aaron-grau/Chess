var React = require('react');
var PropTypes = React.PropTypes;
var BoardStore = require('../stores/board');
var ApiUtil = require('../util/api_util');
var Tile = require('./tile');

var Board = React.createClass({

  getInitialState: function () {
    return {board: BoardStore.get()};
  },

  componentDidMount: function () {
    this.token = BoardStore.addListener(this._boardChange);
    ApiUtil.fetchNewBoard();
  },

  componentWillUnmount: function () {
    this.token.remove()
  },

  _boardChange: function () {
    this.setState({board: BoardStore.get()});
  },

  render: function() {
    var tiles = [];
    for (var i = 0; i < 8; i++) {
      tiles.push([])
      for (var j = 0; j < 8; j++) {
        var color = ((i + j) % 2) ? "dark" : "light";
        tiles[i].push(
          <Tile key={i + j*2}
          pos={[i, j]} color={color}
          pieceColor={this.state.board[i][j].color}
          piece={this.state.board[i][j].piece}/>
        )
      }
    }

    var rows = [];
    for (var i = 0; i < 8; i++) {
      rows.push(<div key={i} className="row group">
        {tiles[i]}
      </div>);
    }

    return (
      <div id="board">
        {rows}
      </div>
    );
  }

});

module.exports = Board;
