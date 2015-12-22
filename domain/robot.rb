class Robot
  def initialize(coordinates:, facing:, board_class: Board,
                 gyroscope_class: Gyroscope)
    @board = board_class.place_in(coordinates)
    @gyroscope = gyroscope_class.new(facing)
  end

  def self.place(x:, y:, facing:)
    new(coordinates: { x: x, y: y }, facing: facing)
  end

  def move
    board.move(self)
    self
  end

  def facing
    gyroscope.where_am_i_facing
  end

  def place(x:, y:, facing:)
    board.place_in(x: x, y: y)
    gyroscope.face_to(facing)
    self
  end

  def position
    board.where_am_i
  end

  def report
    "#{board.report_position},#{gyroscope.report}"
  end

  def rotate_right
    gyroscope.rotate_right
    self
  end

  def rotate_left
    gyroscope.rotate_left
    self
  end

  private

  attr_reader :board, :gyroscope
end

class Gyroscope
  def initialize(cardinal_point)
    @facing = cardinal_point
  end

  def rotate_right
    right_rotation_order = [:north, :east, :south, :west, :north]
    next_cardinal_point = right_rotation_order.find_index(@facing) + 1
    @facing = right_rotation_order[next_cardinal_point]
  end

  def rotate_left
    left_rotation_order = [:north, :west, :south, :east, :north]
    next_cardinal_point = left_rotation_order.find_index(@facing) + 1
    @facing = left_rotation_order[next_cardinal_point]
  end

  def where_am_i_facing
    @facing
  end

  def face_to(cardinal_point)
    @facing = cardinal_point
  end

  def report
    "#{@facing.to_s.upcase}"
  end
end

class Board
  def self.place_in(coordinates)
    x = coordinates.fetch :x
    y = coordinates.fetch :y
    new(x: x, y: y)
  end

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def where_am_i
    [@x, @y]
  end

  def report_position
    "#{@x},#{@y}"
  end

  def place_in(x:, y:)
    @x = x
    @y = y
  end

  def move(robot)
    send("move_#{robot.facing}")
    self
  end

  private

  def move_west
    @x -= 1
  end

  def move_east
    @x += 1
  end

  def move_north
    @y += 1
  end

  def move_south
    @y -= 1
  end
end
