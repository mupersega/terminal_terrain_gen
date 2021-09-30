require 'tty-prompt'
require_relative '../modules/data'
require_relative '../modules/utilities'
require_relative 'world'

class Launcher
  # Launcher class will prepare the user to create and load worlds and is where the user will return to after finishing world creation.
  include Data::Text
  include Utilities::FileFuncs

  def initialize
    @prompt = TTY::Prompt.new
    @text = Data::Text.all_text
    @current_world = nil
  end

  def welcome_user
    first_time = @prompt.no?(@text[:welcome_message])
    if first_time
      puts @text[:bundle_install_text]
    else
      p "ok"
    end
  end

  def thank_user
    puts "thanks for doing things, you're the best!"
  end

  def main_menu
    menu_items = ["create new map", "load a saved map", "help", "quit"]
    input = @prompt.select("You would like to..") do |menu|
      menu.choice menu_items[0]
      menu.choice menu_items[1]
      menu.choice menu_items[2]
      menu.choice menu_items[3]
    end
    case input
    when menu_items[0]
      new_world
    when menu_items[1]
      # subtract_heights
      load_world
    when menu_items[2]
      puts "help info"
    else
      thank_user
      exit!
    end
  end

  def new_world
    # choose sea level
    sl = @prompt.slider("Sea Level", min: -5, max: 5, step: 1, help: "(low = more land, high = more water)", show_help: :always)
    @current_world = World.new(50 + sl)
  end

  def load_world
    # create list all json filenames in maps folder
    files = get_all_file_names_of_type("json", "./maps")
    # prompt select from list
    
    # parse data of chosen json
    # TEST VALIDITY OF HEIGHT MAP
    # @current_world = World.new(data.sl, data.heightmap)
    # def initialize(sea_level, height_map = [], tile_data = [])
    json = JSON.load_file("./maps/test.json")
    @current_world = World.new(json["sea_level"], json["height_map"], json["tiles"])

  end

  def main_loop
    welcome_user
    done = false
    until done
      main_menu
    end
    thank_user
  end
end
