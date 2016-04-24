require_relative '../../../lib/logic/playgame.rb'

class Api::PlaysController < ApplicationController

  def show

  end

  def new
    @board = Board.new
  end

end
