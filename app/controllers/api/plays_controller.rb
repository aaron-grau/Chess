require_relative '../../../lib/logic/game_files.rb'

class Api::PlaysController < ApplicationController

  def update
    board = JSON.parse(params[:board])
    @board = Board.new(board)
    @board.make_any_move(JSON.parse(params[:pos1]), JSON.parse(params[:pos2]))
    @mate = @board.is_mate?("black")
    unless @mate
      computer = ComputerPlayer.new("black")
      cpu_move = computer.play_turn(@board)
      @last_move = cpu_move
      @board.make_any_move(cpu_move[0], cpu_move[1])
      @mate = @board.is_mate?("white")
    end

    render :create
  end

  def create
    @board = Board.new
    @mate = false
  end

end
