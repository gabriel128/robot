require 'rubygems'
require 'bundler/setup'
require 'rspec'
require_relative '../domain/robot'

#TODO
# add board limit validations
# show error when placed multiple times and wrong position
# add integration tests
# discard all commands until robot is placed
# validate robot when placed

describe 'Robot domain' do
  context 'valid' do
    describe 'movement' do
      it { expects_robot_to_move from: [3, 3], to: [2, 3], when_facing: :west }
      it { expects_robot_to_move from: [2, 2], to: [1, 2], when_facing: :west }
      it { expects_robot_to_move from: [1, 4], to: [2, 4], when_facing: :east }
      it { expects_robot_to_move from: [1, 2], to: [2, 2], when_facing: :east }
      it { expects_robot_to_move from: [1, 1], to: [1, 2], when_facing: :north }
      it { expects_robot_to_move from: [1, 2], to: [1, 3], when_facing: :north }
      it { expects_robot_to_move from: [4, 2], to: [4, 1], when_facing: :south }
      it { expects_robot_to_move from: [2, 4], to: [2, 3], when_facing: :south }
    end

    describe 'right rotation' do
      it { expect(robot_facing(:north).rotate_right.facing).to eq :east }
      it { expect(robot_facing(:east).rotate_right.facing).to eq :south }
      it { expect(robot_facing(:south).rotate_right.facing).to eq :west }
      it { expect(robot_facing(:west).rotate_right.facing).to eq :north }
    end

    describe 'left rotation' do
      it { expect(robot_facing(:north).rotate_left.facing).to eq :west }
      it { expect(robot_facing(:west).rotate_left.facing).to eq :south }
      it { expect(robot_facing(:south).rotate_left.facing).to eq :east }
      it { expect(robot_facing(:east).rotate_left.facing).to eq :north }
    end

    describe 'facing' do
      it 'is the same as the movement cardinal point' do
        robot = Robot.place(x: 3, y: 4, facing: :north)
        expect(robot.facing).to be :north
      end
    end

    describe 'placed multiple times' do
      it 'has the last position placed' do
        robot_report = Robot.place(x: 3, y: 4, facing: :north)
          .place(x: 3, y: 4, facing: :west)
          .place(x: 1, y: 2, facing: :south).report
        expect(robot_report).to eq '1,2,SOUTH'
      end
    end

    describe 'reporting' do
      let(:robot) { Robot.place(x: 3, y: 3, facing: :north) }

      it { expect(robot.report).to eq '3,3,NORTH' }
      it { expect(robot.move.report).to eq '3,4,NORTH' }
    end
  end
end

def expects_robot_to_move(from:, to:, when_facing:)
  robot = Robot.place(x: from[0], y: from[1], facing: when_facing).move
  expect(robot.position).to(eq(to),
    "exepcted: #{to}\ngot: #{robot.position}\nwhen facing: " \
    "#{when_facing}\nfrom: #{from}")
end

def robot_facing(cardinal_point)
  Robot.place(x: 3, y: 4, facing: cardinal_point)
end
