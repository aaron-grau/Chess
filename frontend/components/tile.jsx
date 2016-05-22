var React = require('react');
var PropTypes = React.PropTypes;
var DropTarget = require('react-dnd').DropTarget;
var Piece = require('./piece');


var squareTarget = {
  drop: function (props) {
    return {pos2: props.pos};
  }
};

function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  };
};

var Tile = React.createClass({

  render: function() {
    var lastMove = "";
    if (this.props.lastMove) {
      lastMove = "last-move-border";
    }
    var piece = <div></div>;
    var connectDropTarget = this.props.connectDropTarget;
    var isOver = this.props.isOver;
    if (this.props.piece && this.props.piece !== "null") {
      piece = <Piece
        image={this.props.image}
        color={this.props.pieceColor}
        pos={this.props.pos}
        handleMove={this.props.handleMove}
        moves={this.props.moves}
        />
    }

    return (connectDropTarget(
        <div className={this.props.color + " tile " + lastMove}>
          {piece}
          {isOver &&
            <div style={{
              position: 'absolute',
              top: 0,
              left: 0,
              height: '100%',
              width: '100%',
              zIndex: 1,
              opacity: 0.5,
              backgroundColor: 'yellow'
            }} />
          }
        </div>
    ));
  }

});

module.exports = DropTarget("piece", squareTarget, collect)(Tile);
