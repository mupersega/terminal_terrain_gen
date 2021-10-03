# frozen_string_literal: true

require 'rainbow'

require_relative '../modules/utilities'
require_relative '../modules/data'

# Tile represents a single index in the height map with all it's resultant attribs
class Tile
  include Utilities::StringFuncs
  include Utilities::MathFuncs
  include Data::TileData

  attr_reader :colour_export

  def initialize(world, x_pos, y_pos, altitude, kind = nil)
    @world = world
    @x = x_pos
    @y = y_pos
    @altitude = altitude
    @kind = kind.nil? ? establish_kind : kind.to_sym

    @tile_data = Data::TileData.tile_info[@kind]
    @colour_bg = @tile_data[:colour]
    @colour_char = @tile_data[:char_col]
    @colour_export = @tile_data[:exp_col]
    @frames = @tile_data[:frames]
    # choose a random string char out of all options to avoid repetitive tile displays
    @current_frame = rand(@frames.length)
  end

  # this class's JSON representation
  def as_json
    {
      x: @x,
      y: @y,
      altitude: @altitude,
      kind: @kind
    }
  end

  # ascertain and assign terrain kind
  def establish_kind
    underwater = @altitude <= @world.sea_level
    sea_level = @world.sea_level
    max_world_height = @world.height_map.flatten.max
    min_world_height = @world.height_map.flatten.min
    range = underwater ? [min_world_height, sea_level] : [sea_level, max_world_height]
    percentile = percentile_in_range(range, @altitude)
    if underwater
      assign_water_type(percentile)
    else
      assign_land_type(percentile)
    end
  end

  def assign_water_type(percentile)
    if percentile > 0.8
      :water_shallow
    elsif percentile > 0.3
      :water_medium
    else
      :water_deep
    end
  end

  def assign_land_type(percentile)
    if percentile > 0.95
      :land_peak
    elsif percentile > 0.7
      :land_mountain
    elsif percentile > 0.45
      :land_highland
    elsif percentile.positive?
      :land_grassland
    else
      :land_shore
    end
  end

  def draw
    print Rainbow((@frames[@current_frame]).to_s).color(@colour_char.to_sym).bg(@colour_bg.to_sym)
  end

  def to_s
    "<#{pad_string(@x, 2)},#{pad_string(@y, 2)},#{pad_string(@altitude, 2)}> "
  end
end
