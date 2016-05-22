BLACK_PIECES = [
  Rook.new("black", self, [0,0], {has_castled: false, can_castle: true}),
  Knight.new("black", self, [0,1]),
  Bishop.new("black", self, [0,2]),
  Queen.new("black", self, [0,3]),
  King.new("black", self, [0,4], {has_castled: false, can_castle: true}),
  Bishop.new("black", self, [0,5]),
  Knight.new("black", self, [0,6]),
  Rook.new("black", self, [0,7], {has_castled: false, can_castle: true})
]

WHITE_PIECES = [
  Rook.new("white", self, [7,0], {has_castled: false, can_castle: true}),
  Knight.new("white", self, [7,1]),
  Bishop.new("white", self, [7,2]),
  Queen.new("white", self, [7,3]),
  King.new("white", self, [7,4], {has_castled: false, can_castle: true}),
  Bishop.new("white", self, [7,5]),
  Knight.new("white", self, [7,6]),
  Rook.new("white", self, [7,7], {has_castled: false, can_castle: true})
]
