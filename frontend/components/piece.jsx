var React = require('react');
var PropTypes = React.PropTypes;
var DragSource = require('react-dnd').DragSource;

var pieceSource = {
  beginDrag: function (props) {
    return {pos: props.pos, color: props.color};
  },

  endDrag: function (props, monitor, component) {
    if (!monitor.didDrop() || props.color != "white") {
      return;
    }

    var item = monitor.getItem();
    var dropResult = monitor.getDropResult();
    pos1 = item.pos
    pos2 = dropResult.pos2
    moves = props.moves

    legalMove = false
    for (var i = 0; i < moves.length; i++) {
      if (pos2[0] === moves[i][0] && pos2[1] === moves[i][1]) {
        legalMove = true
        break;
      }
    }
    if (legalMove) {
      props.handleMove(pos1, pos2, props.color)
    }
  }
};

function collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }
};

var Piece = React.createClass({

  propTypes: {
    connectDragSource: PropTypes.func.isRequired,
    isDragging: PropTypes.bool.isRequired
  },

  render: function() {
    var connectDragSource = this.props.connectDragSource;
    var isDragging = this.props.isDragging;

    return (
      connectDragSource(
        <img className="piece-image" src={this.props.image}
        style={{
          opacity: isDragging ? 0 : 1,
          cursor: 'pointer'
        }} />
    ));
  }

});

module.exports = DragSource("piece", pieceSource, collect)(Piece)
