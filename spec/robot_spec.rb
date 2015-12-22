require 'rubygems'
require 'bundler/setup'
require 'rspec'
require_relative '../domain/robot'

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

  context 'invalid' do
    describe 'north movement' do
      let(:robot) { Robot.place(x: 4, y: 4, facing: :north) }
      it { expect(robot.move.report).to eq '4,4,NORTH' }
    end
    describe 'east movement' do
      let(:robot) { Robot.place(x: 4, y: 2, facing: :east) }
      it { expect(robot.move.report).to eq '4,2,EAST' }
    end
    describe 'west movement' do
      let(:robot) { Robot.place(x: 0, y: 4, facing: :west) }
      it { expect(robot.move.report).to eq '0,4,WEST' }
    end
    describe 'south movement' do
      let(:robot) { Robot.place(x: 1, y: 0, facing: :south) }
      it { expect(robot.move.report).to eq '1,0,SOUTH' }
    end
    describe 'placing' do
      it 'raises an error'do
        expect { Robot.place(x: 6, y: 9, facing: :south) }
          .to raise_error 'Can not place the robot there'
      end
    end
    describe 'multiple placings' do
      it 'raises an error'do
        expect do
          Robot.place(x: 4, y: 2, facing: :south)
            .place(x: 5, y: 7, facing: :north)
        end.to raise_error 'Can not place the robot there'
      end
    end
  end
end

def expects_robot_to_move(from:, to:, when_facing:)
  robot = Robot.place(x: from[0], y: from[1], facing: when_facing).move
  expect(robot.report).to(eq("#{to[0]},#{to[1]},#{when_facing.to_s.upcase}"),
    "exepcted: #{to}\ngot: #{robot.report}\nwhen facing: " \
    "#{when_facing}\nfrom: #{from}")
end

def robot_facing(cardinal_point)
  Robot.place(x: 3, y: 4, facing: cardinal_point)
end
