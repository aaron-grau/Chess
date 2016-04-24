var React = require('react');
var PropTypes = React.PropTypes;

var Tile = React.createClass({

  render: function() {
    var piece = <div></div>;
    if (this.props.piece && this.props.piece != "String") {
      piece = <div className="piece">{this.props.piece[0]}</div>
    }
    return (
      <div className={this.props.color + " tile"}>
        {piece}
      </div>
    );
  }

});

module.exports = Tile;
