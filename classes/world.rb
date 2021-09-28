require_relative '../modules/utilities'
require_relative 'tile'

class World
  include Utilities::ArrayFuncs

  attr_reader :sea_level, :height_map

  def initialize(sea_level, height_map = [])
    @rows = 25
    @cols = 30
    @min_altitude = 0
    @max_altitude = 100
    @sea_level = sea_level
    @height_map = height_map
    @tiles = []
    # if height map passed, load it, else create a new height map
    @height_map.length.positive? ? set_load_attribs : setup_height_map
    build_tiles(@height_map)
    draw_tiles()
  end

  # build a brand new height map
  def setup_height_map
    # build array of arrays of random values between min & max altitudes
    @height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
    # smooth the initial array x times
    5.times {
      @height_map = smooth_height_map(1)
    }
  end

  # set appropriate attributes if height map supplied
  def set_load_attribs
    @rows = @height_map.length
    @cols = @height_map[0].length
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
