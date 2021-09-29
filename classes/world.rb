require_relative '../modules/utilities'
require_relative 'tile'
require_relative 'terraformer'

class World
  include Utilities::ArrayFuncs

  attr_reader :sea_level, :height_map, :cols, :rows

  def initialize(sea_level, height_map = [])
    @prompt = TTY::Prompt.new
    @rows = 100
    @cols = 30
    @min_altitude = 0
    @max_altitude = 100
    @sea_level = sea_level
    @height_map = height_map
    @tiles = []
    # if height map passed, load it and set attribs, else create a new height map
    @height_map.length.positive? ? set_load_attribs : setup_height_map
    build_tiles(@height_map)
    draw_tiles()
    main_loop()
  end

  # build a brand new height map
  def setup_height_map
    # build array of arrays of random values between min & max altitudes
    @height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
    # smooth the initial array x times
    1.times {
      @height_map = smooth_height_map(2)
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
    # empty current tiles
    @tiles.clear
    # for every value(altitude) in every row, make a new tile at coords (x=row_index, y=col_index) at altitude.
    an_array.each_with_index do |row, row_index|
      row.each_with_index do |altitude, col_index|
        @tiles.push Tile.new(self, row_index, col_index, altitude)
      end
    end
  end

  # debug tool
  def present_height_map
    display_array_padded(@height_map, 2)
  end

  # debug tool - show string representations of all tiles
  def present_tiles
    @tiles.each_with_index do |tile, i|
      puts '' if (i % @cols).zero?
      print tile
    end
    puts ''
  end

  # call draw method of all tiles and space with line breaks
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

  def map_menu
    menu_items = ["add mountains", "add depths", "smooth the map", "save this map", "quit"]
    input = @prompt.select("You would like to..") do |menu|
      menu.choice menu_items[0]
      menu.choice menu_items[1]
      menu.choice menu_items[2]
      menu.choice menu_items[3]
      menu.choice menu_items[4]
    end
    case input
    when menu_items[0]
      add_mountains
    when menu_items[1]
      subtract_heights
    when menu_items[2]
      user_smooth
    when menu_items[3]
      puts "help info"
    else
      thank_user
      exit!
    end
  end

  def add_mountains
    num_nodes = @prompt.slider("How many mountains?", min: 0, max: 10, step: 1)
    size = @prompt.slider("How big would you like them to be?", min: 1, max: 3, step: 1, help: "(1=sml, 2=med, 3=lrg)", show_help: :always)
    num_nodes.times {Terraformer.new(self, rand(@cols), rand(@rows), size, 1)}

  end

  def subtract_heights
    num_nodes = @prompt.slider("How many times?", min: 1, max: 5, step: 1)
    size = @prompt.slider("How greedily, and how deep will you dig?", min: 1, max: 3, step: 1, help: "(1=shallow, 2=deep, 3=moria)", show_help: :always)
    num_nodes.times {Terraformer.new(self, rand(@cols), rand(@rows), size, -1)}

  end

  def user_smooth
    choices = {"a little" => 1, "a lot" => 2}
    smooth_radius = @prompt.select("What size?", choices)
    smooth_radius.times {smooth_height_map(smooth_radius)}
  end

  def main_loop
    done = false
    until done
      map_menu
      build_tiles(@height_map)
      draw_tiles
    end
  end
end
