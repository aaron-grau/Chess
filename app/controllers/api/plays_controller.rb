require_relative '../../../lib/logic/playgame.rb'

class Api::PlaysController < ApplicationController

  def update
    board = JSON.parse(params[:board])
    @board = Board.new(board)

    render :new
  end

  def new
    @board = Board.new
  end

end
