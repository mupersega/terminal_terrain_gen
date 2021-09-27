require 'rainbow'

require_relative '../modules/utilities'
require_relative '../modules/data'

class Tile
	include Utilities::StringFuncs
	include Utilities::MathFuncs
	include Data::TileData

	def initialize(world, x, y, altitude)
		@world = world
		@x = x
		@y = y
		@altitude = altitude
		@kind = establish_kind()

		@tile_data = Data::TileData.tile_info[@kind]
		@colour_bg = @tile_data[:colour]
		@colour_char = @tile_data[:char_col]
		@frames = @tile_data[:frames]
		@current_frame = rand(@frames.length)
		p @current_frame
	end

	def to_s
		
	end


	def establish_kind
		underwater = @altitude <= @world.sea_level ? true : false
		sea_level = @world.sea_level
		max_world_height = @world.height_map.flatten.max
		min_world_height = @world.height_map.flatten.min
		range = underwater ? [min_world_height, sea_level] : [sea_level, max_world_height]
		p range
		p min_world_height
		p max_world_height
		percentile = percentile_in_range(range, @altitude)
		p percentile
		if underwater
			case
			when percentile > 0.8
				return :water_shallow
			when percentile > 0.3
				return :water_medium
			else
				return :water_deep
			end
		else
			case
			when percentile > 0.95
				return :land_peak
			when percentile > 0.7
				return :land_mountain
			when percentile > 0.55
				return :land_highland
			when percentile > 0
				return :land_grassland
			else
				return :land_shore
			end
		end
	end

	def draw
		print Rainbow("#{@frames[@current_frame]}").color(@colour_char.to_sym).bg(@colour_bg.to_sym)
	end

	def to_s
		"<#{pad_string(@x, 2)},#{pad_string(@y, 2)},#{pad_string(@altitude, 2)}> "
	end
end