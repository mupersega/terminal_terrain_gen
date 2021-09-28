require 'tty-prompt'
require_relative '../modules/data'
require_relative 'world'

class Launcher
  # Launcher class will prepare the user to create and load worlds and is where the user will return to after finishing world creation.
  include Data::Text
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
    # @prompt.slider("Sea Level", min: 45, max: 55, step: 1)
  end

  def thank_user
    puts "thanks for doing things, you're the best!"
  end

  def main_menu
    input = @prompt.select("Would you like to..") do |menu|
      menu.choice "create new world"
      menu.choice "load saved world"
      menu.choice "help"
    end
    case input
    when "create new world"
      new_world
    when "load"
      load_world
    else
      puts "help info"
    end
  end

  def new_world
    # choose sea level
    sl = @prompt.slider("Sea Level", min: 45, max: 55, step: 1)
    @current_world = World.new(sl)
  end

  def load_world
    # create list all json filenames in maps folder
    # prompt select from list
    # parse data of chosen json
    # TEST VALIDITY OF HEIGHT MAP
    # @current_world = World.new(data.sl, data.heightmap)
  end

  def main_loop
    welcome_user
    done = false
    until done
      main_menu
      done = @prompt.yes?("you done?")
    end
    thank_user
  end
end
