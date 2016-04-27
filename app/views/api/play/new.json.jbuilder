json.array! @board.grid do |row|
  row.each do |tile|
    json.extract! tile, :class
  end
end
