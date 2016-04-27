var React = require('react');
var PropTypes = React.PropTypes;
var BoardStore = require('../stores/board');
var ApiUtil = require('../util/api_util');
var Tile = require('./tile');
var DragDropContext = require('react-dnd').DragDropContext;
var TouchBackend = require('react-dnd-touch-backend');
var HTML5Backend = require('react-dnd-html5-backend');
var Backend = isTouchDevice() ? TouchBackend : HTML5Backend;

function isTouchDevice() {
  return 'ontouchstart' in window;
}

var Board = React.createClass({

  getInitialState: function () {
    return {board: BoardStore.get(), moved: false, mate: false, lastMove: [[null, null], [null, null]]};
  },

  componentDidMount: function () {
    this.token = BoardStore.addListener(this._boardChange);
    ApiUtil.fetchNewBoard();
  },

  componentWillUnmount: function () {
    this.token.remove()
  },

  _boardChange: function () {
    this.setState({
      board: BoardStore.get(),
      moved: false,
      mate: BoardStore.mate(),
      lastMove: BoardStore.lastMove()
    });
    this.props.toggleMessage(true);
  },

  handleMove: function (pos1, pos2, color) {
    if (!this.state.moved) {
      var letter_board = []
      var board = this.state.board;

      for (var i = 0; i < 8; i++) {
        letter_board.push([]);
        for (var j = 0; j < 8; j++) {
          letter_board[i].push({
            piece: board[i][j].piece,
            color: board[i][j].color,
            can_castle: board[i][j].can_castle,
            has_castled: board[i][j].has_castled
          });
        }
      }
      ApiUtil.makeMove(JSON.stringify(letter_board), JSON.stringify(pos1), JSON.stringify(pos2));

      board[pos2[0]][pos2[1]] = board[pos1[0]][pos1[1]];
      board[pos1[0]][pos1[1]] = {piece: "String"};
      this._castle(pos1, pos2);
      this._queen(pos2);
      this.setState({board: board, moved: true, lastMove: [pos1, pos2]});
      this.props.toggleMessage(false);
    }
  },

  _castle: function (pos1, pos2) {
    var board = this.state.board;

    if (board[pos2[0]][pos2[1]].piece === "King" && Math.abs(pos1[1] - pos2[1]) > 1) {
      if (pos1[1] - pos2[1] < 0) {
        board[pos1[0]][pos1[1] + 1] = board[pos1[0]][pos1[1] + 3]
        board[pos1[0]][pos1[1] + 3] = {piece: "String"}
      } else {
        board[pos1[0]][pos1[1] - 1] = board[pos1[0]][pos1[1] - 4]
        board[pos1[0]][pos1[1] - 4] = {piece: "String"}
      }
    }
  },

  _queen: function (pos2) {
    var board = this.state.board;
    var tile = board[pos2[0]][pos2[1]];
    if (tile.piece === "Pawn" && (pos2[0] === 7 || pos2[0] === 0)) {
      tile.image = tile.queen_img
    }
  },

  render: function() {
    var tiles = [];
    for (var i = 0; i < 8; i++) {
      tiles.push([])
      for (var j = 0; j < 8; j++) {
        var color = ((i + j) % 2) ? "dark" : "light";
        var isLast = false
        if ((i === this.state.lastMove[0][0] && j === this.state.lastMove[0][1]) ||
          (i === this.state.lastMove[1][0] && j === this.state.lastMove[1][1])) {
            isLast = true
          }
        tiles[i].push(
          <Tile key={i + j*2}
          pos={[i, j]}
          color={color}
          pieceColor={this.state.board[i][j].color}
          piece={this.state.board[i][j].piece}
          image={this.state.board[i][j].image}
          moves={this.state.board[i][j].moves}
          handleMove={this.handleMove}
          lastMove={isLast}
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
    var mate = <div></div>
    if (this.state.mate) {
      mate = <div className="mate-message">Checkmate!</div>
    }
    return (
      <div id="board">
        {mate}
        {rows}
      </div>
    );
  }

});


module.exports = DragDropContext(Backend)(Board);
