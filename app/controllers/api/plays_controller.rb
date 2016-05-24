require_relative '../../../lib/logic/game_files.rb'

class Api::PlaysController < ApplicationController
  attr_accessor :mate, :board

  def update
    new_board = JSON.parse(params[:board])

    @board = Board.new(new_board)
    board.make_any_move(JSON.parse(params[:pos1]), JSON.parse(params[:pos2]))
    @mate = board.is_mate?(COLORS[1])

    get_cpu_move unless mate

    render :create
  end

  def create
    @board = Board.new
    @mate = false
  end

  private

  def get_cpu_move
    computer = ComputerPlayer.new(COLORS[1])
    cpu_move = computer.play_turn(board)
    @last_move = cpu_move
    board.make_any_move(cpu_move[0], cpu_move[1])
    @mate = board.is_mate?(COLORS[0])
  end

end
