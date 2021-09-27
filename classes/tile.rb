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
		p @kind
		data = Data::TileData.tile_info[@kind]
		p data
		
		@colour_bg = data[:colour]
		@frames = data[:frames]
	end

	def establish_kind
		underwater = @altitude <= @world.sea_level ? true : false
		sea_level = @world.sea_level
		max_world_height = @world.height_map.flatten.max
		min_world_height = @world.height_map.flatten.min
		range = underwater ? [min_world_height, sea_level] : [sea_level, max_world_height]
		percentile = percentile_in_range(range, @altitude)
		if underwater
			case
			when percentile > 0
				return :water_shallow
			when percentile > 0.3
				return :water_medium
			else
				return :water_deep
			end
		else
			case
			when percentile > 0
				return :land_mountain
			when percentile > 0.3
				return :land_highland
			else
				return :land_grassland
			end
		end
	end

	def draw
		print Rainbow("#{@frames[0]}").bg(@colour_bg.as_sym)
	end

	def to_s
		"<#{pad_string(@x, 2)},#{pad_string(@y, 2)},#{pad_string(@altitude, 2)}> "
	end
end