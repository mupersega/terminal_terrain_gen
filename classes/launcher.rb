require 'tty-prompt'
require_relative '../modules/data'
require_relative 'world'

class Launcher
  # Launcher class will prepare the user to create and load worlds and is where the user will return to after finishing world creation.
  include Data::Text
  def initialize
    @prompt = TTY::Prompt.new
    @text = Data::Text.all_text
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

  def main_loop
    welcome_user
    world = World.new(50)
    world.draw_tiles
    @prompt.yes?("you done?")
  end
end
