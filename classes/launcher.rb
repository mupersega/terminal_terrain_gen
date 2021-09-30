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
    first_time = @prompt.yes?(@text[:welcome_message])
    if first_time
      puts ''
      system 'clear'
    else
      puts @text[:bundle_install_text]
      exit!
    end
    title_screen
  end

  def title_screen
    pretty_pretty_print(Data::Text.title_ascii)
    pretty_pretty_print(Data::Text.home_text)
  end

  def thank_user
    puts "thanks for doing things, you're the best!"
  end

  def main_menu
    pretty_pretty_print(Data::Text.main_menu_ascii)
    puts ""
    menu_items = ["New world", "Load world", "Exit"]
    input = @prompt.select("Here are your options:") do |menu|
      menu.choice menu_items[0]
      menu.choice menu_items[1]
      menu.choice menu_items[2]
    end
    case input
    when menu_items[0]
      new_world
    when menu_items[1]
      load_world
    else
      return true
    end
    return false
  end

  # print real purdy-like
  def pretty_pretty_print(string)
    colours = [:lawngreen, :green, :darkgreen, :seagreen, :darkseagreen, :limegreen, :chartreuse]
    string.each_char { |char| print Rainbow(char).color(colours.sample)}
  end

  def new_world
    # choose sea level
    sl = @prompt.slider("Sea Level", min: -5, max: 5, step: 1, help: "(low = more land, high = more water)", show_help: :always)
    @current_world = World.new(50 + sl)
  end

  def load_world
    # create choice list of all json filenames in maps folder
    begin
      choices = get_all_file_names_of_type("json", "./maps")
      # prompt select from list
      choice = @prompt.select("Choose a map", choices, cycle: true, max: 3)
      # load json file matching name
      json = JSON.load_file("./maps/#{choice}.json")
      # instantiate world with sea level and other data
      @current_world = World.new(json["sea_level"], json)
    rescue NoMethodError
      puts "There are currently no maps to load, create a new one and save to utilize this feature."
    end
  end

  def main_loop
    welcome_user
    done = false
    until done
      done = main_menu
      system 'clear'
    end
    puts 'Thank you, exiting now.'
    sleep(0.2)
    exit!
  end
end
