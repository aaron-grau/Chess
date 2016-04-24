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
  }

};

module.exports = ApiUtil;
