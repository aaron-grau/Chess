var BoardConstants = require('../constants/board_constants');
var AppDispatcher = require('../dispatcher/dispatcher');


var BoardActions = {

  receiveBoard: function (board) {
    AppDispatcher.dispatch({
      actionType: BoardConstants.BOARD_RECEIVED,
      board: board
    });
  }

};

module.exports = BoardActions;
