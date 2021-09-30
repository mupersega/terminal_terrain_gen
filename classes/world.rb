require 'rainbow'
require 'json'

require_relative '../modules/utilities'
require_relative 'tile'
require_relative 'terraformer'

class World
  include Utilities::ArrayFuncs
  include Utilities::FileFuncs

  attr_reader :sea_level, :height_map, :cols, :rows

  def initialize(sea_level, world_data = nil)
    @prompt = TTY::Prompt.new
    @rows = 22
    @cols = 30
    @min_altitude = 0
    @max_altitude = 100
    @sea_level = sea_level
    @world_data = world_data
    @height_map = height_map
    @tiles = []

    @world_data == nil ? build_fresh : build_from_data
    draw_tiles()
    main_loop()
  end

  # build a world from fresh if no data loaded
  def build_fresh
    @height_map = setup_height_map
    instantiate_tiles_from_array(@height_map)
  end

  # build a world from json
  def build_from_data
    @sea_level = @world_data["sea_level"]
    @height_map = @world_data["height_map"]
    @rows = @height_map.length
    @cols = @height_map[0].length
    instantiate_tiles_from_json(@world_data["tiles"])
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

  def smooth_height_map(smooth_radius)
    # run utils func on this' height map
    @height_map = smooth_2d_array(@height_map, smooth_radius)
  end

  def instantiate_tiles_from_array(an_array)
    # empty current tiles
    @tiles.clear
    # for every value(altitude) in every row, make a new tile at coords (x=row_index, y=col_index) at altitude.
    an_array.each_with_index do |row, row_index|
      row.each_with_index do |altitude, col_index|
        @tiles.push Tile.new(self, row_index, col_index, altitude)
      end
    end
  end

  def instantiate_tiles_from_json(tile_data)
    tile_data.each {|tile|
      @tiles.push(Tile.new(self, tile["x"], tile["y"], tile["altitude"], tile["kind"] ))}
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
    menu_items = ["smooth the map", "add heights", "add depths", "save this map", "quit"]
    input = @prompt.select("You would like to..") do |menu|
      menu.choice menu_items[0]
      menu.choice menu_items[1]
      menu.choice menu_items[2]
      menu.choice menu_items[3]
      menu.choice menu_items[4]
    end
    case input
    when menu_items[0]
      user_smooth
    when menu_items[1]
      add_mountains
    when menu_items[2]
      subtract_heights
    when menu_items[3]
      save_world
    else
      thank_user
      exit!
    end
  end

  def add_mountains
    num_nodes = @prompt.slider("How many times?", min: 0, max: 10, step: 1)
    size = @prompt.slider("How big would you like them to be?", min: 1, max: 3, step: 1, help: "(1=sml, 2=med, 3=lrg)", show_help: :always)
    num_nodes.times {Terraformer.new(self, rand(@cols), rand(@rows), size, 1)}

  end

  def subtract_heights
    num_nodes = @prompt.slider("How many times?", min: 0, max: 10, step: 1)
    size = @prompt.slider("How greedily, and how deep will you dig?", min: 1, max: 3, step: 1, help: "(1=shallow, 2=deep, 3=moria)", show_help: :always)
    num_nodes.times {Terraformer.new(self, rand(@cols), rand(@rows), size, -1)}
  end

  def user_smooth
    choices = {"a little" => 1, "a lot" => 2}
    smooth_radius = @prompt.select("Smooth how much?", choices)
    smooth_radius.times {smooth_height_map(smooth_radius)}
  end

  # get world name from user.
  def save_world
    # set loop flag
    valid_name = false
    # final name
    chosen_name = nil
    # return all maps in maps folder
    all_maps = get_all_file_names_of_type("json", "./maps/")
    # loop until valid name 
    until valid_name
      map_name = get_validated_map_name
      # if name exists would user like to overwrite map
      if all_maps.include? map_name
        valid_name = @prompt.yes?("This map already exists, would you like to overwrite it?")
      else
        valid_name = true
      end
    end
    puts "saving world"
    export_world(chosen_name)
  end

  def get_validated_map_name
    name = @prompt.ask("What would you like to name this map?", help: "Alphabet only, max size 10 characters.") do |q|
      q.validate(/^[a-zA-Z]{0,10}$/, "File name must contain #{Rainbow("LETTERS").red} only, and be no more than #{Rainbow("10").red} characters long")
    end
    return name
  end

  def export_world(name, path="./maps/test.json")
    new_json = {
      name: name,
      sea_level: @sea_level,
      height_map: @height_map,
      tiles: @tiles.map {|tile| tile.as_json() }
    }
    File.open(path, 'w') { |file| file.write(JSON.pretty_generate(new_json))}
  end

  def main_loop
    done = false
    until done
      map_menu
      instantiate_tiles_from_array(@height_map)
      draw_tiles
    end
  end
end
