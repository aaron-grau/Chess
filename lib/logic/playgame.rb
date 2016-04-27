require_relative 'display/string'
require_relative 'game/illegal_move_error'
require_relative "display/display"
require_relative 'pieces/piece'
require_relative 'pieces/sliding_piece'
require_relative 'pieces/stepping_piece'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/pawn'
require_relative 'game/board'
require_relative 'AI/undo_move'
require_relative 'AI/node'
require_relative 'game/game'
require_relative 'game/human_player'
require_relative 'AI/computer_player'

require 'colorize'
require 'byebug'

player1 = HumanPlayer.new("white")
player2 = ComputerPlayer.new("black")

game = Game.new(player1, player2)

game.play_game
