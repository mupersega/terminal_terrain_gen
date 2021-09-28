require_relative '../modules/utilities'
require_relative 'tile'

class World
  include Utilities::ArrayFuncs

  attr_reader :sea_level, :height_map

  def initialize(sea_level = 50, height_map = [])
    @rows = 20
    @cols = 40
    @min_altitude = 0
    @max_altitude = 100
    @sea_level = sea_level
    @height_map = height_map
    @tiles = []
    @height_map.length.positive? ? build_tiles(@height_map) : setup
  end

  def setup
    # build array of arrays of random values between min & max altitudes
    @height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
    # smooth the initial array arg=smooth radius
    3.times {
      @height_map = smooth_height_map(2)
    }
    # instantiate tiles
    build_tiles(@height_map)
  end

  def smooth_height_map(smooth_radius)
    # run utils func on this' height map
    @height_map = smooth_2d_array(@height_map, smooth_radius)
  end

  def build_tiles(an_array)
    # for every value(altitude) in every row, make a new tile at coords (x=row_index, y=col_index) at altitude.
    an_array.each_with_index do |row, row_index|
      row.each_with_index do |altitude, col_index|
        @tiles.push Tile.new(self, row_index, col_index, altitude)
      end
    end
  end

  def present_height_map
    display_array_padded(@height_map, 2)
  end

  # used primarily for debugging, show string representations of all tiles
  def present_tiles
    @tiles.each_with_index do |tile, i|
      puts '' if (i % @cols).zero?
      print tile
    end
    puts ''
  end

  def draw_tiles
    @tiles.each_with_index do |tile, i|
      if (i % @cols).zero?
        puts ''
        print "\t"
      end
      tile.draw
      # sleep(0.005)
    end
    puts ''
    puts ''
  end

  def main_loop; end
end
