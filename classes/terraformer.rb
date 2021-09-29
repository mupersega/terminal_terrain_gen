

class Terraformer
  def initialize(world, x, y, size, polarity)
    @world = world
    @x = x
    @y = y
    @walks = 5
    @size = size
    @polarity = polarity
    @work_array = @world.height_map
    main_loop
  end
  
  def spawn_node
    @walks.times do
      random_walk(@x, @y)
    end
  end

  def random_walk(start_x, start_y)
    walk_life = rand(15) * @size
    start_value = @world.sea_level + @size * 10 * @polarity
    x = start_x
    y = start_y
    while walk_life != 0
      alter_value(start_value, x, y)
      x, y = choose_next_pos(x, y)
      walk_life -= 1
      start_value -= @polarity
    end
  end

  def choose_next_pos(x, y)
    directions = [-1, 0, 1]
    new_x = (x + directions.sample) % @world.cols
    new_y = (y + directions.sample) % @world.rows
    return [new_x, new_y]
  end

  def alter_value(amt, x, y)
    @work_array[y][x] = amt
  end

  def main_loop
    spawn_node()
  end

end