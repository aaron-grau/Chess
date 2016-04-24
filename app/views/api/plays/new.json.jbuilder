pieces = []

@board.grid.each do |row|
  pieces << []
  row.each do |tile|
    if tile.class == String
      pieces.last << {piece: tile.class.to_s}
    else
      pieces.last << {piece: tile.class.to_s, color: tile.color}
    end
  end
end

json.array! pieces
