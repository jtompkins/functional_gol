require 'set'
require 'codependent'

require_relative './cell'
require_relative './printer'

class GetNeighbors
  def call(cell)
    Cell::DIRECTIONS.map { |direction| DeadCell.at(cell, direction) }
  end
end

class CountLiveNeighbors
  # def initialize(get_neighbors)
  #   @get_neighbors = get_neighbors
  # end

  attr_accessor :get_neighbors

  def call(cell, live_cells)
    get_neighbors.(cell).count { |n| live_cells.include?(n) }
  end
end

class IsAlive
  # def initialize(count_live_neighbors)
  #   @count_live_neighbors = count_live_neighbors
  # end

  attr_accessor :count_live_neighbors

  def call(cell, live_cells)
    case count_live_neighbors.(cell, live_cells)
    when 2
      LiveCell.from(cell) if cell.is_a?(LiveCell)
    when 3
      LiveCell.from(cell)
    end
  end
end

class Runner
  # def initialize(get_neighbors, is_alive)
  #   @get_neighbors = get_neighbors
  #   @is_alive = is_alive
  # end

  attr_accessor :get_neighbors, :is_alive

  def call(live_cells)
    live_cells
      .reduce(Set.new(live_cells)) { |acc, elem| acc.merge(get_neighbors.(elem)) }
      .map { |cell| is_alive.(cell, live_cells) }
      .compact
  end
end

container = Codependent::Container.new do
  singleton :printer do
    with_value Printer.new
  end

  singleton :get_neighbors do
    with_value GetNeighbors.new
  end

  singleton :count_live_neighbors do
    with_value CountLiveNeighbors.new

    depends_on :get_neighbors
  end

  singleton :is_alive do
    with_value IsAlive.new

    depends_on :count_live_neighbors
  end

  singleton :runner do
    with_value Runner.new

    depends_on :get_neighbors, :is_alive
  end
end

runner = container.resolve(:runner)
printer = container.resolve(:printer)

live_cells = [LiveCell.new(1, 0), LiveCell.new(1, 1), LiveCell.new(1, 2)]

10.times do
  live_cells = runner.(live_cells)
  printer.(live_cells)
end
