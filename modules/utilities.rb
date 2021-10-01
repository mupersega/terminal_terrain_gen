# frozen_string_literal: true

# These Utilities must have no reference to other projects.
module Utilities
  # --MATH FUNCTIONS-- #
  module MathFuncs
    # return average of nums in array
    def average(arr)
      arr.sum / arr.size
    end

    # return the percentile of a number within a range
    def percentile_in_range(range, value)
      range_window = range[1] - range[0]
      val_in_context = value - range[0]
      val_in_context / range_window.to_f
    end
  end

  # --STRING FUNCTIONS-- #
  module StringFuncs
    # return a string at a set size to ensure clean printing
    def pad_string(string, desired_string_length, filler = '0')
      # assigning vars only for cleaner code
      s = string.to_s
      dsl = desired_string_length
      f = filler
      # if string is larger than desired, slice it
      if s.length > dsl
        s.slice(0..s.length)
      # if smaller than desired add filler chars
      elsif s.length < dsl
        s.rjust(dsl, f)
      # otherwise it is exact size and return as is
      else
        s
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
      r.times { new_array << c.times.map { rand(min..max) } }
      new_array
    end

    # smooth an array with average pooling, also known as convolution
    # smooth_radius is how many cells around the main cell should be used to contribute to the pool.
    # PLEASE NOTE!!! THIS FUNC IS DELIBERATELY VERBOSE, RUBOCOP SHHHH!!
    def smooth_2d_array(arr, smooth_radius)
      # prepare new array
      new_array = []
      sr = smooth_radius
      # attain dimensions/shape of array.
      total_rows = arr.length
      total_cols = arr[0].length
      # for each row
      arr.each_with_index do |row, row_index|
        new_row = []
        # for each value in that row get
        row.each_with_index do |_val, col_index|
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
      new_array
    end

    # return array of average of values at every index of a num of arrays
    def average_arrays(nested_array)
      joined_arr = []
      num_cols = nested_array[0].length
      num_arrays = nested_array.length
      num_cols.times do |i|
        current_sum = 0
        nested_array.each { |array| current_sum += array[i] }
        joined_arr << current_sum / num_arrays.to_f
      end
      joined_arr
    end

    # display values in array with no padding or delimiter one row at a time
    def display_array_clean(arr)
      arr.each do |line|
        line.each do |val|
          print val
        end
        puts ''
      end
    end

    # display values in array delimited with a "," justified to the right, and filled with "0"s
    def display_array_padded(arr, length, _filler = '0')
      arr.each do |line|
        line.each do |val|
          print "#{pad_string(val, length)},"
        end
        puts ''
      end
    end
  end

  # --File Functions-- #
  module FileFuncs
    # return a list of file names of a type without the file extension
    def get_all_file_names_of_type(extension, path)
      # get all files in path
      full_file_names = Dir.entries(path).select { |f| File.file? File.join(path, f) }
      files = []
      full_file_names.each do |name|
        # split file into name and extension
        file_breakdown = name.split('.')
        file_breakdown[1] == extension ? files << file_breakdown[0] : next
      end
      files
    end
  end
end
