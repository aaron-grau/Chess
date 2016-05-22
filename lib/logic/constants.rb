COLORS = ["white", "black"]

BLACK_PIECES = [
  Rook.new(COLORS[1], self, [0,0], {has_castled: false, can_castle: true}),
  Knight.new(COLORS[1], self, [0,1]),
  Bishop.new(COLORS[1], self, [0,2]),
  Queen.new(COLORS[1], self, [0,3]),
  King.new(COLORS[1], self, [0,4], {has_castled: false, can_castle: true}),
  Bishop.new(COLORS[1], self, [0,5]),
  Knight.new(COLORS[1], self, [0,6]),
  Rook.new(COLORS[1], self, [0,7], {has_castled: false, can_castle: true})
]

WHITE_PIECES = [
  Rook.new(COLORS[0], self, [7,0], {has_castled: false, can_castle: true}),
  Knight.new(COLORS[0], self, [7,1]),
  Bishop.new(COLORS[0], self, [7,2]),
  Queen.new(COLORS[0], self, [7,3]),
  King.new(COLORS[0], self, [7,4], {has_castled: false, can_castle: true}),
  Bishop.new(COLORS[0], self, [7,5]),
  Knight.new(COLORS[0], self, [7,6]),
  Rook.new(COLORS[0], self, [7,7], {has_castled: false, can_castle: true})
]

VALUES = {
 Pawn => 1,
 Knight => 3,
 Bishop => 3,
 Rook => 5,
 Queen => 9,
 King => 10000
}
