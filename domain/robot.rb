require_relative 'gyroscope'
require_relative 'legs'
require_relative 'board_position'

class Robot
  def initialize(board_position:, facing:,
                 gyroscope_class: Gyroscope, leg_class: Legs)
    @legs = leg_class.stand_in(board_position)
    @gyroscope = gyroscope_class.new(facing)
  end

  def self.place(x:, y:, facing:)
    new(board_position: BoardPosition.new(x: x, y: y), facing: facing)
  end

  def move
    legs.walk(self)
    self
  end

  def facing
    gyroscope.where_am_i_facing
  end

  def place(x:, y:, facing:)
    legs.walk_to(BoardPosition.new(x: x, y: y))
    gyroscope.face_to(facing)
    self
  end

  def report
    "#{legs.report_position},#{gyroscope.report}"
  end

  def rotate_right
    gyroscope.rotating_right
    self
  end

  def rotate_left
    gyroscope.rotating_left
    self
  end

  private

  attr_reader :legs, :gyroscope
end
