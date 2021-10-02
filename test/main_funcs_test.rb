# frozen_string_literal: true

require 'test/unit'
require_relative '../modules/utilities'

# tests for the main array functions
class RandArrayTests < Test::Unit::TestCase
  include Utilities::ArrayFuncs
  include Utilities::MathFuncs
  # check that world instantiates and that sea level attribute matches
  def setup
    @rows = 30
    @columns = 60
    @min_value = 0
    @max_value = 100
    @testable_array = random_2d_array(@rows, @columns, @min_value, @max_value)
    @smoothed_array = smooth_2d_array(@testable_array, 1)
  end

  # number of array should match number of rows
  def test_number_of_nested_arrays
    assert_equal(@rows, @testable_array.length, 'Incorrect number of rows created')
  end

  # number of values per array should equal columns
  def test_size_of_nested_array
    assert_equal(@columns, @testable_array[0].length, 'Incorrect number of values in each row')
  end

  # check all values in array are below or equal to max value
  def test_all_values_below_max
    assert_block do
      @testable_array.flatten.max <= @max_value
    end
  end

  # check all values in array are above or equal to min value
  def test_all_values_above_min
    assert_block do
      @testable_array.flatten.max >= @min_value
    end
  end

  # this test is interesting because even though an array has been smoothed
  # the average value of the smoothed array should still equal the same as the random array
  def test_same_average_of_arrays
    assert_equal(average(@testable_array.flatten), average(@smoothed_array.flatten))
  end
end
