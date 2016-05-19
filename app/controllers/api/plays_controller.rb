require_relative '../../../lib/logic/playgame.rb'

class Api::PlaysController < ApplicationController

  def update
    # Need Board.create_from_json(params[:board])
    board = JSON.parse(params[:board])
    @board = Board.new(board)

    # delegate this to a method that processes next move
    @board.make_any_move(JSON.parse(params[:pos1]), JSON.parse(params[:pos2]))
    @mate = @board.is_mate?("black")
    unless @mate
      computer = ComputerPlayer.new("black")
      cpu_move = computer.play_turn(@board)
      @last_move = cpu_move
      @board.make_any_move(cpu_move[0], cpu_move[1])
      @mate = @board.is_mate?("white")
    end

    render :new
  end

  # be semantic. Use show to render a board, create to make a new one, etc.
  def create
    @board = Board.new
    @mate = false
  end

end
