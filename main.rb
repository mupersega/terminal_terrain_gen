max_height = 20
# Make a rand array with looping
start_time = Time.new
looped_array = []

10.times {looped_array << 16.times.map {rand(max_height)}}
# 16.times.map {rand(max_height)}
# p looped_array
# p Time.now - start_time

seeds = []

start_time = Time.new
10.times {seeds << Random.new_seed}

# p seeds
# p Time.now - start_time

def pretty_print_array(arr)
    arr.each do |line|
        print line
        puts ""
    end
    puts "--" * 20
end

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

def smooth_array(arr)
    smooth_rad = 1
    new_array = []
    arr.each_with_index do |row, row_index|
        new_row = []
        row.each_with_index do |val, col_index|
            x_range_min = col_index - smooth_rad
            x_range_max = col_index + smooth_rad
            x_range = Array(x_range_min, x_range_max)
            y_range_min = row_index - smooth_rad
            Y_range_max = row_index + smooth_rad
            y_range = Array(y_range_min, y_range_max)
            y_range.each do |y_range_val|
                x_range.each do end
            end
        end

        new_array << new_row
    end
end


# p looped_array
pretty_print_array(looped_array)
