class BoardPosition
  attr_reader :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def valid?
    x >= 0 && x <= 4 && y >= 0 && y <= 4
  end
end
