# These Utilities must have no reference to other projects.
module Utilities
	# --MATH FUNCTIONS-- #
	module MathFuncs
		# return average of nums in array
		def average(arr)
			return arr.sum / arr.size
		end
		# return the percentile of a number within a range
		def percentile_in_range(range, value)
			range_window = range[0] - range[1]
			val_in_context = value - range[0]
			percentile = val_in_context / range_window.to_f
			return percentile
		end
	end

	# --STRING FUNCTIONS-- #
	module StringFuncs

		def pad_string(string, desired_string_length, filler="0")
			# assigning vars only for cleaner code
			s = string.to_s
			dsl = desired_string_length
			f = filler
			# if string is larger than desired, slice it
			if s.length > dsl
				return s.slice(0..s.length)
			# if smaller than desired add filler chars
			elsif s.length < dsl
				return s.rjust(dsl, f)
			# otherwise it is exact size and return as is
			else
				return s
			end
		end
	end

	# --ARRAY FUNCTIONS-- #
	module ArrayFuncs
		include MathFuncs
		include StringFuncs

		# create a random array of given dimensions.
		def random_2d_array(total_rows, num_columns, min_value, max_value)
			r = total_rows
			c = num_columns
			min = min_value
			max = max_value
			new_array = []
			r.times {new_array << c.times.map {rand(min..max)}}
			return new_array
		end

		# smooth an array with average pooling. This is also known as convolution. smooth_radius is how many cells around the main cell should be used to contribute to the pool.
		def smooth_2d_array(arr, smooth_radius)
			# prepare new array
			new_array = []
			sr = smooth_radius
			# attain dimensions/shape of array.
			total_rows = arr.length()
			total_cols = arr[0].length()
			# for each row
			arr.each_with_index do |row, row_index|
				new_row = []
				# for each value in that row get
				row.each_with_index do |val, col_index|
					# track values from nearby indexes
					surrounding_values = []
					# set x(row) index bounds from home location
					x_range_min = col_index - sr
					x_range_max = col_index + sr
					# set y(column) index bounds from home location
					y_range_min = row_index - sr
					y_range_max = row_index + sr
					# create a range(list) of row indexes from the bounds
					x_range = Array(x_range_min..x_range_max)
					# create a range(list) of column indexes from the bounds
					y_range = Array(y_range_min..y_range_max)
					# for each row index
					y_range.each do |y_range_val|
						# for every column in that row (within x range)
						x_range.each do |x_range_val|
							# prepare vars with modulo to allow wrapping of arrays
							row = y_range_val % total_rows
							col = x_range_val % total_cols
							# push value at index to list of surrounding values
							surrounding_values << arr[row][col]
						end
					end
					# get the average of surrounding values and push to new_row
					new_row << average(surrounding_values)
				end
				# push row of averaged values to new_array
				new_array << new_row
			end
			return new_array
		end
			
		# display values in array with no padding or delimiter one row at a time
		def display_array_clean(arr)
			arr.each do |line|
				line.each do |val|
						print val
				end
				puts ""
			end
		end

		# display values in array delimited with a "," justified to the right, and filled with "0"s
		def display_array_padded(arr, length, filler="0")
			arr.each do |line|
				line.each do |val|
					print "#{pad_string(val, length)},"
				end
				puts ""
			end
		end

    end

end
