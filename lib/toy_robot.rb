require_relative '../domain/robot_order_translator.rb'

class OrderInput
  def initialize
    @robot_translator = RobotOrderTranslator.new
  end

  def recursive_order(order)
    return if order.upcase == 'EXIT'
    @robot_translator.order_robot_to(order) do |response|
      response.on_success do |message|
        puts message if order.upcase == 'REPORT'
        recursive_order($stdin.gets.chop)
      end
      response.on_fail do |message|
        puts "Failure: #{message}"
      end
    end
  end
end

puts 'Welcome to the Toy Robot Simulator, place your command'
puts '(Do not forget to place the robot first)'
OrderInput.new.recursive_order($stdin.gets.chop)
