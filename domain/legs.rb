require_relative 'board'

class Legs
  def self.stand_in(board_position)
    new(board_position: board_position)
  end

  def initialize(board_position:, board: Board.new)
    @board = board
    @board_position = board_position
  end

  def walk(robot)
    @board_position = board.new_position(facing: robot.facing,
      current_position: board_position)
  end

  def walk_to(board_position)
    @board_position = board_position
  end

  def report_position
    "#{board_position.x},#{board_position.y}"
  end

  private

  attr_reader :board, :board_position
end
