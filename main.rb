require 'rainbow'
require_relative 'modules/utilities'

include Utilities::ArrayFuncs

# def create_random_2d_array(total_rows, num_columns, min_value, max_value)
#     r = total_rows
#     c = num_columns
#     min = min_value
#     max = max_value
#     new_array = []
#     r.times {new_array << c.times.map {rand(min..max)}}
#     return new_array
# end

# def pretty_print_array(arr)
#     arr.each do |line|
#         line.each do |val|
#             case val
#             when "~,~"
#                 print Rainbow(val).color(:navyblue).bg(:navyblue)
#             when "~.~"
#                 print Rainbow(val).blue.bg(:blue)
#             when "'.'"
#                 print Rainbow(val).color(:khaki).bg(:yellow)
#             when " - "
#                 print Rainbow(val).yellow.bg(:green)
#             else
#                 print Rainbow(val).color(:slategray).bg(:darkslategray)
#             end
#         end
#         puts ""
#     end
#     puts "--" * 20
# end

# smooth_array(arr)
    # make empty array to take lists of averages
    # for every row
        # make an empty row to receive averaged value
        # for each value (smooth radius 1 tile)
            # make empty list to hold surrounding values surr_values
            # set start_row and end_row (current row - smooth radius, current row + smooth radius + 1?)
            # set start_col and end_col (current col - smooth radius, current col + smooth radius + 1?)
            # for range start_row -> end_row |r|
                # for range start_col -> end col |c|
                    # surr_values << arr[r][c]

def smooth_array(arr, smooth_radius)
    smooth_rad = smooth_radius
    total_rows = arr.length()
    total_cols = arr[0].length()
    new_array = []
    # for each row
    arr.each_with_index do |row, row_index|
        new_row = []
        # for each value in that row
        row.each_with_index do |val, col_index|
            # track values from nearby indexes
            surrounding_values = []
            # set x(row) index bounds from home location
            x_range_min = col_index - smooth_rad
            x_range_max = col_index + smooth_rad
            # set y(column) index bounds from home location
            y_range_min = row_index - smooth_rad
            y_range_max = row_index + smooth_rad
            # create a range(list) of row indexes from the bounds
            x_range = Array(x_range_min..x_range_max)
            # create a range(list) of column indexes from the bounds
            y_range = Array(y_range_min..y_range_max)
            # for each row index
            y_range.each do |y_range_val|
                # for every column in that row within x range
                x_range.each do |x_range_val|
                    # prepare vars with modulo to allow wrapping of arrays
                    row = y_range_val % total_rows
                    col = x_range_val % total_cols
                    surrounding_values << arr[row][col]
                end
            end
            height = average(surrounding_values)
            sea_level = 16
            case
            when height < 9
                char = "~,~"
            when height < 11
                char = "~.~"
            when height == 11
                char = "'.'"
            when (height > 11 && height < 13)
                char = " - "
            else
                char = " ^ "
            end
            new_row << char
        end
        new_array << new_row
    end
    return new_array
end

def average(arr)
    return arr.sum / arr.size
end

rows = 25
cols = 40
min_value = 0
max_value = 20
# looped_array = create_random_2d_array(rows, cols, min_value, max_value)

# smooth_array(looped_array, 2)

# pretty_print_array(smooth_array(looped_array, 2))

new_arr = random_2d_array(rows, cols, min_value, max_value)

new_arr = smooth_2d_array(new_arr, 2)
display_array_clean(new_arr)

