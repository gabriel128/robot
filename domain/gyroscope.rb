class Gyroscope
  RIGHT_ROTATION_ORDER = [:north, :east, :south, :west, :north]
  LEFT_ROTATION_ORDER = [:north, :west, :south, :east, :north]

  def initialize(cardinal_point)
    @facing = cardinal_point
  end

  def rotating_right
    facing_next_cardinal_point(with: RIGHT_ROTATION_ORDER)
  end

  def rotating_left
    facing_next_cardinal_point(with: LEFT_ROTATION_ORDER)
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

  private

  def facing_next_cardinal_point(with:)
    @facing = with[with.find_index(@facing) + 1]
  end
end
