require 'rubygems'
require 'bundler/setup'
require 'response_callback'
require_relative '../domain/robot'

class RobotOrderTranslator
  COMMANDS_TO_METHOD = { 'PLACE' => :order_to_place,
                         'LEFT' => :order_left,
                         'RIGHT' => :order_right,
                         'MOVE' => :order_move,
                         'REPORT' => :order_report }

  def order_robot_to(order)
    fail 'Place the robot first' unless place_is_the?(order) || robot_placed?
    method = COMMANDS_TO_METHOD.fetch(get_first_word_from(order))
    response = send(method, order)
    yield ResponseCallback::Success.new yield_var: response if block_given?
  rescue => e
    yield ResponseCallback::Fail.new yield_var: e.message if block_given?
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

  def order_left(_order)
    robot.rotate_left
  end

  def order_right(_order)
    robot.rotate_right
  end

  def order_move(_order)
    robot.move
  end

  def order_report(_order)
    "Output: #{robot.report}"
  end
end
