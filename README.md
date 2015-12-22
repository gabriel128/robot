# Toy Robot Simulator

A command line simulation of a toy robot moving on a square tabletop, 
of dimensions 5 units x 5 units. There are not any kind of obstruction and 
the robot is free to roam around the surface of the table, and he is clever
enough to recognize the board limits, so don't worry, he won't break!

## Enviroment
 
  There is no specific OS requirment

## Dependencies

  `Bundler >= 1.11.0`
  `ruby >= 2.2.2`

## Installation

 After cloning the repo, cd to the root directory and invoke:

 `bundle install`

## Usage

To run the application in interactive mode, invoke:

`$ ruby lib/toy_robot.rb`

Permitted commands are: 

  ```
    PLACE,MOVE,LEFT,RIGHT,REPORT

    PLACE X,Y,F (i.e PLACE 2,3,NORTH): to place the robot on the board
      F: NORTH, SOUTH, EAST, WEST
      X: from 0 to 4
      Y: from 0 to 4

    MOVE: to move the robot on step forward where the robot is facing
    LEFT: to rotate the robot to the left
    RIGHT: to rotate the robot to the right
    REPORT: to report where the is the robot at the moment.

  ```
# Example 

  ![Example Gif](gif_example/output.gif)

# Testing Instructions

To run all specs invoke:

  `bin/rspec`

# Overview

The commands are case insensitive, so is the same if you write NORTH or NorTh. If you want, 
you are able to place the robot multiple times, take into account that you will receive a failure
message if the robot is not placed and you try to execute commands on the robot.

# Contributing

1. Fork it ( https://github.com/gabriel128/if_true_if_false/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This work is under a GPL v3 license.
