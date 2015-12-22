require_relative '../domain/robot'

class RobotOrderTranslator
  COMMANDS_TO_MESSAGES = { 'PLACE' => :order_to_place,
                           'LEFT' => :order_left,
                           'RIGHT' => :order_right,
                           'MOVE' => :order_move,
                           'REPORT' => :order_report }

  def order_robot_to(order)
    fail 'Place the robot first' unless place_is_the?(order) || robot_placed?
    message = COMMANDS_TO_MESSAGES.fetch(get_first_word_from(order))
    send(message, order)
  rescue => e
    puts "Failure: #{e.message}"
  end

  private

  attr_reader :robot

  def get_first_word_from(order)
    order.split.first.upcase
  end

  def place_is_the?(order)
    get_first_word_from(order) == 'PLACE'
  end

  def robot_placed?
    robot != nil
  end

  def order_to_place(order)
    x, y, facing = order.split[1].split(',')
    @robot = Robot.place(x: x.to_i, y: y.to_i, facing: facing.downcase.to_sym)
  end

  def order_left(order)
    robot.rotate_left
  end

  def order_right(order)
    robot.rotate_right
  end

  def order_move(order)
    robot.move
  end

  def order_report(order)
    "Output: #{robot.report}"
  end
end
