require 'rubygems'
require 'bundler/setup'
require 'rspec'
require_relative '../domain/robot_order_translator.rb'

describe 'Robot order translator', 'Integration tests' do
  context 'valid' do
    let(:rot) { RobotOrderTranslator.new }
    describe 'just placing' do
      it 'places the robot and report that place' do
        rot.order_robot_to('PLACE 3,4,NORTH')
        expect_report_to_eq(message: 'Output: 3,4,NORTH', translator: rot)
      end
      it 'places the robot multiple times' do
        rot.order_robot_to('PLACE 3,4,NORTH')
        rot.order_robot_to('PLACE 2,4,NORTH')
        expect_report_to_eq(message: 'Output: 2,4,NORTH', translator: rot)
      end
    end

    describe 'command case-insensitiveness' do
      it 'does not care about case' do
        rot.order_robot_to('PLaCE 3,4,NOrTH')
        rot.order_robot_to('LEfT')
        rot.order_robot_to('mOVE')
        rot.order_robot_to('RIGhT')
        expect_report_to_eq(message: 'Output: 2,4,NORTH', translator: rot)
      end
    end

    describe 'move robot 1 step to the west' do
      it 'reports in step west' do
        rot.order_robot_to('PLACE 3,4,NORTH')
        rot.order_robot_to('LEFT')
        rot.order_robot_to('MOVE')
        expect_report_to_eq(message: 'Output: 2,4,WEST', translator: rot)
      end
    end

    describe 'move robot 1 step to the right' do
      it 'reports in step right' do
        rot.order_robot_to('PLACE 1,3,NORTH')
        rot.order_robot_to('RIGHT')
        rot.order_robot_to('MOVE')
        expect_report_to_eq(message: 'Output: 2,3,EAST', translator: rot)
      end
    end

    describe 'example cases' do
      it 'case a' do
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('MOVE')
        expect_report_to_eq(message: 'Output: 0,1,NORTH', translator: rot)
      end
      it 'case b' do
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('LEFT')
        expect_report_to_eq(message: 'Output: 0,0,WEST', translator: rot)
      end
      it 'case c' do
        rot.order_robot_to('PLACE 1,2,EAST')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('LEFT')
        rot.order_robot_to('MOVE')
        expect_report_to_eq(message: 'Output: 3,3,NORTH', translator: rot)
      end
    end
  end

  context 'invalid' do
    describe 'placing' do
      let(:rot) { RobotOrderTranslator.new }
      it 'shows error when wrong coordinates' do
        rot.order_robot_to('PLACE 5,7,NORTH') do |response|
          response.on_fail do |message|
            expect(message).to eq 'Can not place the robot there'
          end
        end
      end
      it 'shows error when is not the first command' do
        rot.order_robot_to('MOVE') do |response|
          response.on_fail do |message|
            expect(message).to eq 'Place the robot first'
          end
        end
      end
      it 'shows error when failed and try to move' do
        rot.order_robot_to('PLACE 0,9,NORTH')
        rot.order_robot_to('MOVE') do |response|
          response.on_fail do |message|
            expect(message).to eq 'Place the robot first'
          end
        end
      end
      it 'recovers from failure' do
        rot.order_robot_to('PLACE 0,9,NORTH')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('PLACE 0,9,NORTH')
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('MOVE')
        expect_report_to_eq(message: 'Output: 0,1,NORTH', translator: rot)
      end
    end
  end
end

def expect_report_to_eq(translator:, message:)
  rot.order_robot_to('REPORT') do |response|
    response.on_success do |response_message|
      expect(response_message).to eq message
    end
  end
end
