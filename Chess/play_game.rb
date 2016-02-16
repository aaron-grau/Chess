require_relative 'string'
require_relative 'illegal_move_error'
require_relative "display"
require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'pawn'
require_relative 'board'
require_relative 'game'
require_relative 'human_player'
require_relative 'computer_player'

require 'colorize'
require 'byebug'

player1 = HumanPlayer.new("white")
player2 = ComputerPlayer.new("black")

game = Game.new(player1, player2)

game.play_game
