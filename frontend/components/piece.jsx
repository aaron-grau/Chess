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
    // When dropped on a compatible target, do something.
    // Read the original dragged item from getItem():
    var item = monitor.getItem();
    // You may also read the drop result from the drop target
    // that handled the drop, if it returned an object from
    // its drop() method.
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
      <div style={{
        opacity: isDragging ? 0 : 1,
        fontSize: 25,
        fontWeight: 'bold',
        cursor: 'pointer'
      }}>
        <img className="piece-image" src={this.props.image} />
      </div>
    ));
  }

});

module.exports = DragSource("piece", pieceSource, collect)(Piece)
