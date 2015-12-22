require_relative '../domain/robot'

class RobotOrderTranslator
  def initialize
    @orders = []
    @r = nil
  end

  def order_robot_to(order)
    fail 'Place the robot first' unless(order.upcase.include? 'PLACE') || @r != nil
    if order.upcase.include? 'PLACE'
      x, y, facing = order.split[1].split(',')
      @r = Robot.place(x: x.to_i, y: y.to_i, facing: facing.downcase.to_sym)
    elsif order.upcase == 'LEFT'
      @r.rotate_left
    elsif order.upcase == 'RIGHT'
      @r.rotate_right
    elsif order.upcase == 'MOVE'
      @r.move
    elsif order.upcase == 'REPORT'
      "Output: #{@r.report}"
    end

  rescue => e
    puts "Failure: #{e.message}"
  end
end
