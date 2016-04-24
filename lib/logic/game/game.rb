class Game

  attr_reader :board
  def initialize(player1, player2)
    @board, @player1, @player2, @curr_player =
      Board.new, player1, player2, player1
  end

  def play_game
    until board.is_mate?("white") || board.is_mate?("black")
      begin
        board.move(@curr_player.play_turn(board))
      rescue IllegalMoveError => e
        if @curr_player.is_a?(HumanPlayer)
          puts e.message
        end
        retry
      end
      if board.in_check?('white') || board.in_check?('black')
        print "Check "
      end
      switch_player
    end
    display = Display.new(board)
    display.render([])
    print "Check Mate!" if board.is_mate?("black") || board.is_mate?("white")
  end

  def switch_player
    #debugger
    return @curr_player = @player2 if @curr_player == @player1
    @curr_player = @player1
  end
end
