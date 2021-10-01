require 'test/unit'
require 'tty-prompt'
require_relative '../classes/world'

class WorldTest < Test::Unit::TestCase
  # check that world instantiates and that sea level attribute matches 
  # move to return and exit for test to clear
  def test_create
    sea_level = 50
    world = World.new(sea_level)
    assert_equal(sea_level, world.sea_level)
  end
end
