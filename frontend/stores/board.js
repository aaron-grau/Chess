var Store = require('flux/utils').Store;
var AppDispatcher = require('../dispatcher/dispatcher');
var BoardConstants = require('../constants/board_constants');

var BoardStore = new Store(AppDispatcher);

var _board = [];

for (var i = 0; i < 8; i++) {
  _board.push([]);
  for (var j = 0; j < 8; j++) {
    _board[i].push([]);
  }
}

BoardStore.get = function () {
	return _board.slice(0);
};


BoardStore.__onDispatch = function (payload) {
	switch (payload.actionType) {
		case BoardConstants.BOARD_RECEIVED:
			_board = payload.board;
			BoardStore.__emitChange();
	}
};


module.exports = BoardStore;
