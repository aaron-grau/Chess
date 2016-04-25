var Store = require('flux/utils').Store;
var AppDispatcher = require('../dispatcher/dispatcher');
var BoardConstants = require('../constants/board_constants');

var BoardStore = new Store(AppDispatcher);

var _board = [];
var _mate = false;
var _lastMove = [[null, null], [null, null]];

for (var i = 0; i < 8; i++) {
  _board.push([]);
  for (var j = 0; j < 8; j++) {
    _board[i].push([]);
  }
}

BoardStore.get = function () {
	return _board.slice(0);
};

BoardStore.mate = function () {
  return _mate;
};

BoardStore.lastMove = function () {
  return _lastMove;
};


BoardStore.__onDispatch = function (payload) {
	switch (payload.actionType) {
		case BoardConstants.BOARD_RECEIVED:
			_board = payload.board;
      _mate = payload.mate;
      if (payload.lastMove) {
        _lastMove = payload.lastMove;
      } else {
        _lastMove = [[null, null], [null, null]];
      }
			BoardStore.__emitChange();
	}
};


module.exports = BoardStore;
