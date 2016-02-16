class Game

  attr_reader :board
  def initialize(player1, player2)
    @board = Board.new()
    @player1 = player1
    @player2 = player2
    @curr_player = player1
  end

  def play_game
    until board.is_mate?("white") || board.is_mate?("black")
      begin
        #debugger
        board.move(@curr_player.play_turn(board))
      rescue IllegalMoveError => e
        p e.message
        sleep(2)
        retry
      end
      if board.in_check?('white') || board.in_check?('black')
        print "Check "
        sleep(1) unless board.is_mate?("black") || board.is_mate?("white")
      end
      switch_player
    end
    print "Mate" if board.is_mate?("black") || board.is_mate?("white")
  end

  def switch_player
    #debugger
    return @curr_player = @player2 if @curr_player == @player1
    @curr_player = @player1
  end
end
