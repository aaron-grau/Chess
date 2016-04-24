pieces = []

@board.grid.each do |row|
  pieces << []
  row.each do |tile|
    pieces.last << {piece: tile.class.to_s}
  end
end

json.array! pieces
