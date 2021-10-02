# frozen_string_literal: true

begin
  require 'test/unit'
  require 'tty-prompt'
  require_relative '../classes/world'
rescue LoadError
  puts 'There has been an error loading the necessary dependencies.'
  puts "Please:
    1. navigate to the root directory of this application,
    2. run './terra',
    3. press [i] to install all required dependencies."
  exit!
end

class WorldTest < Test::Unit::TestCase
  # check that world instantiates and that sea level attribute matches,
  # move to return and exit for test to clear
  def test_create
    sea_level = 50
    world = World.new(sea_level)
    assert_equal(sea_level, world.sea_level)
  end
end
