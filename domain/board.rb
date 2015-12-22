require_relative 'board_position'

class Board
  def initialize(board_position: BoardPosition)
    @board_position = board_position
  end

  def new_position(facing:, current_position:)
    send("next_#{facing}_position", current_position)
  end

  private

  attr_reader :board_position

  def next_west_position(current_position)
    board_position.new(x: current_position.x - 1, y: current_position.y)
  end

  def next_east_position(current_position)
    board_position.new(x: current_position.x + 1, y: current_position.y)
  end

  def next_north_position(current_position)
    board_position.new(x: current_position.x, y: current_position.y + 1)
  end

  def next_south_position(current_position)
    board_position.new(x: current_position.x, y: current_position.y - 1)
  end
end
