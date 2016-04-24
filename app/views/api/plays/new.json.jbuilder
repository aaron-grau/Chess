pieces = []

@board.grid.each do |row|
  pieces << []
  row.each do |tile|
    if tile.class == String
      pieces.last << {piece: tile.class.to_s}
    else
      pieces.last << {
        piece: tile.class.to_s,
        color: tile.color,
        image: image_path("#{tile.color[0]}_#{tile.class.to_s.downcase}.png"),
        moves: tile.legal_moves(@board)
      }
    end
  end
end

json.array! pieces
