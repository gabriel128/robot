class Robot
  attr_reader :facing

  def self.place(x:, y:, facing:)
    new.place x: x, y: y, facing: facing
  end

  def move
    send("move_#{facing}")
    self
  end

  def place(x:, y:, facing:)
    @x = x
    @y = y
    @facing = facing
    self
  end

  def position
    [@x, @y]
  end

  def report
    "#{@x},#{@y},#{@facing.to_s.upcase}"
  end

  def rotate_right
    right_rotation_order = [:north, :east, :south, :west, :north]
    next_cardinal_point = right_rotation_order.find_index(@facing) + 1
    @facing = right_rotation_order[next_cardinal_point]
    self
  end

  def rotate_left
    left_rotation_order = [:north, :west, :south, :east, :north]
    next_cardinal_point = left_rotation_order.find_index(@facing) + 1
    @facing = left_rotation_order[next_cardinal_point]
    self
  end

  private

  def move_west
    @x -= 1
    self
  end

  def move_east
    @x += 1
    self
  end

  def move_north
    @y += 1
    self
  end

  def move_south
    @y -= 1
    self
  end
end
