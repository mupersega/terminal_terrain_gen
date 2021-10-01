# frozen_string_literal: true

# Terraformer is the event class which spawns random walks
# which move throughout the array changing values up or down
class Terraformer
  def initialize(world, x_pos, y_pos, size, polarity)
    @world = world
    @x = x_pos
    @y = y_pos
    @walks = 5
    @size = size
    @polarity = polarity
    @work_array = @world.height_map
    main_loop
  end

  # from location spawn number of random walks
  def spawn_node
    @walks.times do
      random_walk(@x, @y)
    end
  end

  # random walk moves changing values until 0 life
  def random_walk(start_x, start_y)
    # set life
    walk_life = rand(15) * @size
    # set how high low value starts from size of terraformer
    start_value = @world.sea_level + @size * 10 * @polarity
    x = start_x
    y = start_y
    # loop until 'dead'
    while walk_life != 0
      # set height map value
      alter_value(start_value, x, y)
      # move to neighbour
      x, y = choose_next_pos(x, y)
      # decay life and set value
      walk_life -= 1
      start_value -= @polarity
    end
  end

  # randomize a location nearby and set new x & y
  def choose_next_pos(x, y)
    directions = [-1, 0, 1]
    new_x = (x + directions.sample) % @world.cols
    new_y = (y + directions.sample) % @world.rows
    [new_x, new_y]
  end

  # change value of height map at index of current xy pos
  def alter_value(amt, x, y)
    @work_array[y][x] = amt
  end

  # main run loop
  def main_loop
    spawn_node
  end
end
