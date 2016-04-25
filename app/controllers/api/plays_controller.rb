require_relative '../../../lib/logic/playgame.rb'

class Api::PlaysController < ApplicationController

  def update
    board = JSON.parse(params[:board])
    @board = Board.new(board)
    @board.make_any_move(JSON.parse(params[:pos1]), JSON.parse(params[:pos2]))
    computer = ComputerPlayer.new("black")
    cpu_move = computer.play_turn(@board)
    @board.make_any_move(cpu_move[0], cpu_move[1])
    render :new
  end

  def new
    @board = Board.new
  end

end
