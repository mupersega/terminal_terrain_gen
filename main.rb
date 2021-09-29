require 'tty-prompt'
require_relative 'modules/utilities'
require_relative 'classes/world'
require_relative 'classes/launcher'

# # WORLD DEBUG
# sea_level = 48
# world = World.new(sea_level)
# world.draw_tiles()

# LAUNCHER DEBUG
launcher = Launcher.new
launcher.main_loop

# return a list of file names of a type without the file extension
def get_all_file_names_of_type(path, extension)
  # get all files in path
  full_file_names = Dir.entries(path).select { |f| File.file? File.join(path, f) }
  files = []
  full_file_names.each do |name|
    # split file into name and extension
    file_breakdown = name.split(".")
    file_breakdown[1] == extension ? full_file_names << file_breakdown[0] : next
  end
  return files
end

# def load_world
#   # create list all json filenames in maps folder
#   files = Dir.entries("./maps").select { |f| File.file? File.join("./maps", f) }
#   p files
#   # prompt select from list
#   # parse data of chosen json
#   # TEST VALIDITY OF HEIGHT MAP
#   # @current_world = World.new(data.sl, data.heightmap)
# end

# get_all_json("./maps")