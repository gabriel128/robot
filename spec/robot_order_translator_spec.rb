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
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 3,4,NORTH'
      end
      it 'places the robot multiple times' do
        rot.order_robot_to('PLACE 3,4,NORTH')
        rot.order_robot_to('PLACE 2,4,NORTH')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 2,4,NORTH'
      end
    end

    describe 'command case-insensitiveness' do
      it 'does not care about case' do
        rot.order_robot_to('PLaCE 3,4,NOrTH')
        rot.order_robot_to('LEfT')
        rot.order_robot_to('mOVE')
        rot.order_robot_to('RIGhT')
        expect(rot.order_robot_to('REPORt')).to eq 'Output: 2,4,NORTH'
      end
    end

    describe 'move robot 1 step to the west' do
      it 'reports in step west' do
        rot.order_robot_to('PLACE 3,4,NORTH')
        rot.order_robot_to('LEFT')
        rot.order_robot_to('MOVE')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 2,4,WEST'
      end
    end

    describe 'move robot 1 step to the right' do
      it 'reports in step right' do
        rot.order_robot_to('PLACE 1,3,NORTH')
        rot.order_robot_to('RIGHT')
        rot.order_robot_to('MOVE')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 2,3,EAST'
      end
    end

    describe 'example cases' do
      it 'case a' do
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('MOVE')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 0,1,NORTH'
      end
      it 'case b' do
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('LEFT')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 0,0,WEST'
      end
      it 'case c' do
        rot.order_robot_to('PLACE 1,2,EAST')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('LEFT')
        rot.order_robot_to('MOVE')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 3,3,NORTH'
      end
    end
  end

  context 'invalid' do
    describe 'placing' do
      let(:rot) { RobotOrderTranslator.new }
      it 'shows error when wrong coordinates' do
        expect(STDOUT).to receive(:puts)
          .with('Failure: Can not place the robot there')
        rot.order_robot_to('PLACE 5,7,NORTH')
      end
      it 'shows error when is not the first command' do
        expect(STDOUT).to receive(:puts)
          .with('Failure: Place the robot first')
        rot.order_robot_to('MOVE')
      end
      it 'shows error when failed and try to move' do
        rot.order_robot_to('PLACE 0,9,NORTH')
        expect(STDOUT).to receive(:puts)
          .with('Failure: Place the robot first')
        rot.order_robot_to('MOVE')
      end
      it 'recovers from failure' do
        rot.order_robot_to('PLACE 0,9,NORTH')
        rot.order_robot_to('MOVE')
        rot.order_robot_to('PLACE 0,9,NORTH')
        rot.order_robot_to('PLACE 0,0,NORTH')
        rot.order_robot_to('MOVE')
        expect(rot.order_robot_to('REPORT')).to eq 'Output: 0,1,NORTH'
      end
    end
  end
end
