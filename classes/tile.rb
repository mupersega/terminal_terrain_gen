require_relative '../modules/utilities'

class Tile
	include Utilities::StringFuncs
	def initialize(x, y, altitude)
		@x = x
		@y = y
		@altitude = altitude
	end

	def to_s
		"<#{pad_string(@x, 2)},#{pad_string(@y, 2)},#{pad_string(@altitude, 2)}> "
	end
end