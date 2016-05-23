var BoardActions = require('../actions/board_actions');

var ApiUtil = {

  fetchNewBoard: function () {
    $.ajax({
      type: "POST",
      url: "/api/play",
      dataType: "json",
      success: function (board_status) {
        var board = board_status.board;
        var mate = board_status.mate;
        var lastMove = board_status.last_move;
        BoardActions.receiveBoard(board, mate, lastMove);
      },
    });
  },

  makeMove: function (board, pos1, pos2) {
    $.ajax({
      type: "PATCH",
      url: "/api/play",
      dataType: "json",
      data: {board: board, pos1: pos1, pos2: pos2},
      success: function (board_status) {
        var board = board_status.board;
        var mate = board_status.mate;
        var lastMove = board_status.last_move;
        BoardActions.receiveBoard(board, mate, lastMove);
      },
    });
  }

};

module.exports = ApiUtil;
