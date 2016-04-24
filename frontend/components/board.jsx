var React = require('react');
var PropTypes = React.PropTypes;
var BoardStore = require('../stores/board');
var ApiUtil = require('../util/api_util');
var Tile = require('./tile');
var DragDropContext = require('react-dnd').DragDropContext;
var HTML5Backend = require('react-dnd-html5-backend');


var Board = React.createClass({

  getInitialState: function () {
    return {board: BoardStore.get(), moved: false};
  },

  componentDidMount: function () {
    this.token = BoardStore.addListener(this._boardChange);
    ApiUtil.fetchNewBoard();
  },

  componentWillUnmount: function () {
    this.token.remove()
  },

  _boardChange: function () {
    this.setState({board: BoardStore.get(), moved: false});
  },

  handleMove: function (pos1, pos2, color) {
    if (!this.state.moved) {
      var board = this.state.board;
      board[pos2[0]][pos2[1]] = board[pos1[0]][pos1[1]];
      board[pos1[0]][pos1[1]] = {piece: "String"};
      this.setState({board: board, moved: true});
      letter_board = []
      for (var i = 0; i < 8; i++) {
        letter_board.push([]);
        for (var j = 0; j < 8; j++) {
          letter_board[i].push([{piece: board[i][j].piece, color: board[i][j].color}]);
        }
      }

      ApiUtil.makeMove(JSON.stringify(letter_board));
    }
  },

  render: function() {
    var tiles = [];
    for (var i = 0; i < 8; i++) {
      tiles.push([])
      for (var j = 0; j < 8; j++) {
        var color = ((i + j) % 2) ? "dark" : "light";
        tiles[i].push(
          <Tile key={i + j*2}
          pos={[i, j]}
          color={color}
          pieceColor={this.state.board[i][j].color}
          piece={this.state.board[i][j].piece}
          image={this.state.board[i][j].image}
          moves={this.state.board[i][j].moves}
          handleMove={this.handleMove}
          />
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

module.exports = DragDropContext(HTML5Backend)(Board);
