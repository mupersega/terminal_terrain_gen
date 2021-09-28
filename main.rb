
require_relative 'modules/utilities'
require_relative 'classes/world'

include Utilities::ArrayFuncs

rows = 19
cols = 40
min_value = 0
max_value = 100
sea_level = 50

# new_arr = random_2d_array(rows, cols, min_value, max_value)

# new_arr = smooth_2d_array(new_arr, 2)
# display_array_clean(new_arr)

world = World.new(rows, cols, min_value, max_value, sea_level)

# world.present_height_map()
world.draw_tiles()
