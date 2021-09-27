require_relative '../modules/utilities'
require_relative 'tile'

class World
	include Utilities::ArrayFuncs
	
	def initialize(rows, cols, min_altitude, max_altitude)
		@rows = rows
		@cols = cols
		@min_altitude = min_altitude
		@max_altitude = max_altitude
		@height_map = []
		@tiles = []
		setup()
	end

	def setup
		# build array of arrays of random values between min & max altitudes
		@height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
		# smooth the initial array arg=smooth radius
		@height_map = smooth_height_map(1)
		build_tiles(@height_map)
	end

	def smooth_height_map(smooth_radius)
		# run utils func on this' height map
		@height_map = smooth_2d_array(@height_map, smooth_radius)
	end

	def build_tiles(an_array)
		# for every value(altitude) in every row, make a new tile at coords (x=row_index, y=col_index) at altitude.
		an_array.each_with_index do |row, row_index|
			row.each_with_index do |altitude, col_index|
				@tiles.push Tile.new(row_index, col_index, altitude)
			end
		end
	end

	# used primarily for debugging, show string representations of all tiles
	def present_tiles
		@tiles.each_with_index do |tile, i|
			if i % @cols == 0
				puts ""
			end
			print tile
		end
		puts ""
	end

end