var BoardActions = require('../actions/board_actions');

var ApiUtil = {

  fetchNewBoard: function () {
    $.ajax({
      type: "GET",
      url: "/api/play/new",
      dataType: "json",
      success: function (board) {
        BoardActions.receiveBoard(board);
      },
    });
  },

  makeMove: function (board, pos1, pos2) {
    $.ajax({
      type: "PATCH",
      url: "/api/play",
      dataType: "json",
      data: {board: board, pos1: pos1, pos2: pos2},
      success: function (board) {
        BoardActions.receiveBoard(board);
      },
    });
  }

};

module.exports = ApiUtil;
