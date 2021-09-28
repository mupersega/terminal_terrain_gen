require_relative '../modules/utilities'
require_relative 'tile'

class World
	include Utilities::ArrayFuncs

	attr_reader :sea_level, :height_map
	
	def initialize(rows, cols, min_altitude, max_altitude, sea_level)
		@rows = rows
		@cols = cols
		@min_altitude = min_altitude
		@max_altitude = max_altitude
		@sea_level = sea_level
		@height_map = []
		@tiles = []
		setup()
	end

	def setup
		# build array of arrays of random values between min & max altitudes
		@height_map = random_2d_array(@rows, @cols, @min_altitude, @max_altitude)
		# present_height_map()
		# smooth the initial array arg=smooth radius
		@height_map = smooth_height_map(4)
		# present_height_map()
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
				@tiles.push Tile.new(self, row_index, col_index, altitude)
			end
		end
	end

	def present_height_map
		display_array_padded(@height_map, 2)
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

	def draw_tiles
		@tiles.each_with_index do |tile, i|
			if i % @cols == 0
				puts ""
				print"	"
			end
			tile.draw()
			# sleep(0.005)
		end
		puts ""
		puts ""
	end

	def main_loop
		
	end

end