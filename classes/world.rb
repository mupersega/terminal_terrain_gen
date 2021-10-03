# frozen_string_literal: true

require 'rainbow'
require 'chunky_png'
require 'json'
require 'tty-progressbar'

require_relative '../modules/utilities'
require_relative 'tile'
require_relative 'terraformer'

# World class is a singleton and is instantiated by Launcher
# World class build and manages all Tile class objects
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
    @name = nil
    @sea_level = sea_level
    @world_data = world_data
    @height_map = height_map
    @tiles = []

    @world_data.nil? ? build_fresh : build_from_data
    draw_tiles
    main_loop
  end

  # build a world from fresh if no data loaded
  def build_fresh
    setup_height_map
    instantiate_tiles_from_array(@height_map)
  end

  # build a world from json
  def build_from_data
    @name = @world_data['name']
    @sea_level = @world_data['sea_level']
    @height_map = @world_data['height_map']
    @rows = @height_map.length
    @cols = @height_map[0].length
    instantiate_tiles_from_json(@world_data['tiles'])
  end

  # build a brand new height map
  def setup_height_map
    # build array of arrays of random values between min & max altitudes
    @height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
    # smooth the initial array x times
    2.times { @height_map = smooth_height_map(1) }
  end

  def smooth_height_map(smooth_radius)
    # run utils func on this' height map
    @height_map = smooth_2d_array(@height_map, smooth_radius)
  end

  def instantiate_tiles_from_array(an_array)
    # empty current tiles
    @tiles.clear
    # set up build progress bar with counters
    total_tiles = @rows * @cols
    build_progress = TTY::ProgressBar.new("Building tiles |:bar|",
      total: 50,
      complete: Rainbow('░').color(:gold).bg(:green),
      incomplete: Rainbow('>').color(:darkslategray)
    )
    total_tiles = @rows * @cols
    tile_count = 0.0
    # for every value(altitude) in every row, make a new tile at coords (x=row_index, y=col_index) at altitude.
    an_array.each_with_index do |row, row_index|
      row.each_with_index do |altitude, col_index|
        @tiles.push Tile.new(self, row_index, col_index, altitude)
        tile_count += 1
        build_progress.ratio = tile_count / total_tiles
      end
    end
    system 'clear'
  end

  def instantiate_tiles_from_json(tile_data)
    tile_data.each do |tile|
      @tiles.push(Tile.new(self, tile['x'], tile['y'], tile['altitude'], tile['kind']))
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
    # world name display
    pretty_pretty_print('World Name: ')
    print (@name.nil? ? Rainbow('map not yet saved...').color(:crimson) : Rainbow(@name).color(:black).bg(:gold)).to_s
    # run draw method on all tiles
    @tiles.each_with_index do |tile, i|
      # if new row add line break
      if (i % @cols).zero?
        puts ''
        print "\t"
      end
      tile.draw
    end
    puts ''
  end

  # prepare and display map menu with colour
  def map_menu
    menu_items = %w[
      Smooth
      Raise
      Dig
      Save
      Return
    ]

    menu_items = menu_items.map { |item| Rainbow(item).color(:gold) }
    input = @prompt.select(
      pretty_pretty_print('What would you like to do?'), symbols: { marker: Rainbow('>>').color(:black).bg(:gold) }
    ) do |menu|
      menu.choice menu_items[0]
      menu.choice menu_items[1]
      menu.choice menu_items[2]
      menu.choice menu_items[3]
      menu.choice menu_items[4]
    end
    case input
    when menu_items[0]
      user_smooth
      false
    when menu_items[1]
      add_height
      false
    when menu_items[2]
      subtract_height
      false
    when menu_items[3]
      save_world
    else
      true
    end
  end

  def add_height
    num_nodes = @prompt.slider('How many times?', min: 0, max: 10, step: 1)
    size = @prompt.slider("How much?\n|1) a bit |2) some |3) lots |", min: 1, max: 3, step: 1)
    num_nodes.times { Terraformer.new(self, rand(@cols), rand(@rows), size, 1) }
    rebuild_tiles
  end

  def subtract_height
    num_nodes = @prompt.slider('How many times?', min: 0, max: 10, step: 1)
    size = @prompt.slider("How greedily, and how deep?\n|1) shallow |2) deep |3) Moria |", min: 1, max: 3, step: 1)
    num_nodes.times { Terraformer.new(self, rand(@cols), rand(@rows), size, -1) }
    rebuild_tiles
  end

  def user_smooth
    choices = { 'a little' => 1, 'a lot' => 2 }
    smooth_radius = @prompt.select('Smooth how much?', choices)
    smooth_radius.times { smooth_height_map(smooth_radius) }
    rebuild_tiles
  end

  # save a world to maps/valid_name.json
  def save_world
    # set loop flag
    name_is_valid = false
    # return all maps in maps folder
    all_maps = get_all_file_names_of_type('json', './maps/')
    # loop until valid name
    until name_is_valid
      map_name = return_valid_name
      # if name exists would user like to overwrite map
      if all_maps.include? map_name
        @prompt.yes?('This map already exists, would you like to overwrite it?') ? name_is_valid = true : return
      else
        name_is_valid = true
      end
    end
    @name = map_name.to_s
    export_world_img(map_name)
    export_world_json(map_name)
  end

  def return_valid_name
    puts Rainbow('Name must be between 1-12 characters and contain letters only.*').color(:darkslategray)
    pretty_pretty_print("What would you like to name this map?\n")
    @prompt.ask('World Name: ') do |q|
      q.validate(/^[a-zA-Z]{1,12}$/, "File name must contain #{
        Rainbow('LETTERS').red} only, and be between #{Rainbow('1 - 12').red} characters long")
    end
  end

  def display_save_timer(msg, total_time, time_steps)
    save_bar = TTY::ProgressBar.new("Saving |:bar|",
      total: time_steps,
      complete: Rainbow('░').color(:gold).bg(:green),
      incomplete: Rainbow('>').color(:darkslategray)
    )
    step = total_time.to_f / time_steps
    time_steps.times do
      sleep(step)
      save_bar.advance
    end
    puts msg
    if @prompt.yes?('continue?')
      rebuild_tiles
    else
      puts 'Thank you, exiting now.'
      sleep(0.2)
      exit!
    end
  end

  def export_world_json(name, path = './maps')
    path = "#{path}/#{name}.json"
    new_json = {
      name: name,
      sea_level: @sea_level,
      height_map: @height_map,
      tiles: @tiles.map(&:as_json)
    }
    begin
      File.open(path, 'w') { |file| file.write(JSON.pretty_generate(new_json)) }
      display_save_timer("Map data #{Rainbow(name + ".json").color(:gold)} saved", 2, 15)
    rescue
      puts 'unfortunately there was a problem saving map data, check that there are no map data files currently open.'
    end
  end

  def export_world_img(name, path = './maps')
    img_from_array_of_colours(tiles_as_colour_array, 10, path, name)
  end

  def tiles_as_colour_array
    colour_array = []
    current_row = []
    # for each tile
    @tiles.each do |tile|
      # add tiles colour to array
      current_row << tile.colour_export
      # if end of row, push and begin new row
      (next unless (current_row.size % @cols).zero? && !current_row.empty?)
      colour_array.push(current_row.clone)
      current_row.clear
    end
    colour_array
  end

  def img_from_array_of_colours(colour_array, cell_width, save_path, name)
    mod = cell_width
    height = colour_array.size
    width = colour_array[0].size
    # create base image with of black at final dimensions
    img = ChunkyPNG::Image.new(width * cell_width, height * cell_width, ChunkyPNG::Color.rgb(0, 0, 0))
    # for every row of colours
    colour_array.each_with_index do |row_of_colours, y|
      # for every colour in row
      row_of_colours.each_with_index do |colour_value, x|
        # change rows of pixels to colour value
        # for every row
        mod.times do |pixel_y|
          # for every column
          mod.times do |pixel_x|
            # pixel_colour = ChunkyPNG::Color.rgb(
            #   colour_value[0], colour_value[1], colour_value[2]
            # )
            pixel_colour = ChunkyPNG::Color(colour_value)
            img[x * mod + pixel_x, y * mod + pixel_y] = pixel_colour
          end
        end
      end
    end

    begin
      img.save("#{save_path}/#{name}.png", :interlace => true)
      puts "Map thumbnail image #{Rainbow(name + ".png").color(:gold)} saved"
    rescue Errno::EINVAL
      puts Rainbow("The image has not been saved, please check that an image file of  name '#{name}.jpg is not currently open. Close file and try saving again if you want a png representation of the current map.").color(:crimson)
      @prompt.keypress('press any key to continue...')
    end
  end

  def rebuild_tiles
    system 'clear'
    instantiate_tiles_from_array(@height_map)
    draw_tiles
  end

  # print all purdy-like
  def pretty_pretty_print(string)
    colours = %i[
      lawngreen
      green
      darkgreen
      seagreen
      darkseagreen
      limegreen
      chartreuse
    ]
    string.each_char { |char| print Rainbow(char).color(colours.sample) }
    nil
  end

  def main_loop
    done = false
    until done
      done = map_menu
    end
  end
end
