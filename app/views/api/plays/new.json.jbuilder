pieces = []

@board.grid.each do |row|
  pieces << []
  row.each do |tile|
    if tile.class == String
      pieces.last << {piece: tile.class.to_s}
    elsif tile.class == Pawn
      pieces.last << {
        piece: tile.class.to_s,
        color: tile.color,
        image: image_path("#{tile.color[0]}_#{tile.class.to_s.downcase}.png"),
        moves: tile.legal_moves(@board),
        can_castle: tile.can_castle,
        has_castled: tile.has_castled,
        queen_img: image_path("#{tile.color[0]}_queen.png")
      }
    else
      pieces.last << {
        piece: tile.class.to_s,
        color: tile.color,
        image: image_path("#{tile.color[0]}_#{tile.class.to_s.downcase}.png"),
        moves: tile.legal_moves(@board),
        can_castle: tile.can_castle,
        has_castled: tile.has_castled
      }
    end
  end
end

json.board pieces
json.mate @mate
json.last_move @last_move
