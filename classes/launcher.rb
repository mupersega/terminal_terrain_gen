# frozen_string_literal: true

require 'tty-prompt'
require_relative '../modules/data'
require_relative '../modules/utilities'
require_relative 'world'

# Launcher class handles main menu and instantiating new Worlds.
class Launcher
  # Launcher class will prepare the user to create
  # and load worlds and is where the user will return to after finishing world creation.
  include Data::Text
  include Utilities::FileFuncs

  def initialize
    @prompt = TTY::Prompt.new
    @current_world = nil
  end

  def title_screen
    system 'clear'
    pretty_pretty_print(Data::Text.title_ascii)
    pretty_pretty_print(Data::Text.home_text)
  end

  def main_menu
    pretty_pretty_print(Data::Text.main_menu_ascii)
    puts ''
    menu_items = [
      Rainbow('               --New World--').color(:gold),
      Rainbow('              --Load World--').color(:gold),
      Rainbow('                 --Exit--').color(:gold)
    ]
    input = @prompt.select('') do |menu|
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
    false
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

  # instantiate new World class
  def new_world
    # choose sea level
    sl = @prompt.slider('          Sea Level:', min: -5, max: 5, step: 1)
    @current_world = World.new(50 + sl)
  end

  # instantiate new World class FROM JSON data
  def load_world
    # create choice list of all json filenames in maps folder
    choices = get_all_file_names_of_type('json', './maps')
    # prompt select from list
    choice = @prompt.select('Choose a map', choices, cycle: true, max: 3)
    # load json file matching name
    json = JSON.load_file("./maps/#{choice}.json")
    # instantiate world with sea level and other data
    @current_world = World.new(json['sea_level'], json)
  # ERROR-HANDLING being used here to catch when no files available to load.
  rescue NoMethodError
    puts Rainbow('You have NO maps to load, to utilize this feature...').color(:crimson)
    puts Rainbow("create a 'New world' and 'Save'.\nreturning...").color(:crimson)
    @prompt.yes?('continue?')
  end

  def main_loop
    title_screen
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
