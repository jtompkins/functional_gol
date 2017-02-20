require 'set'
require_relative './cell'

class Composed
  def initialize(left, right)
    @left = left
    @right = right
  end

  attr_reader :left, :right

  def >>(other)
    self.class.new(self, other)
  end

  def call(value)
    right.(*Array(left.call(value)))
  end

  alias_method :[], :call
end

module Pipeline
  def >>(other)
    Composed.new(self, other)
  end
end

class CalculateNeighbors
  include Pipeline

  def call(cell)
    Cell::DIRECTIONS.map { |direction| DeadCell.from(cell, at: direction) }
  end
end

class CountLiveNeighbors
  include Pipeline

  def initialize(live_cells)
    @live_cells = live_cells
  end

  attr_reader :live_cells

  def call(neighbors)
    neighbors.count { |n| live_cells.include?(n) }
  end
end

class IsAlive
  include Pipeline

  def initialize(cell)
    @cell = cell
  end

  attr_reader :cell

  def call(live_count)
    case live_count
    when 2
      cell if cell.is_a?(LiveCell)
    when 3
      LiveCell.from(cell)
    end
  end
end

class CellsToCheck
  include Pipeline

  def initialize
    @calculator = CalculateNeighbors.new
  end

  attr_reader :calculator

  def call(live_cells)
    [ live_cells.reduce(Set.new(live_cells)) { |acc, elem| acc.merge(calculator.(elem)) }, live_cells ]
  end
end

class Evaluator
  include Pipeline

  def call(cells, live_cells)
    get_neighbors = CalculateNeighbors.new
    count_live_neighbors = CountLiveNeighbors.new(live_cells)

    cells.map do |c|
      should_be_alive = IsAlive.new(c)

      (get_neighbors
        .>> count_live_neighbors
        .>> should_be_alive
      ).(c)
    end.compact
  end
end

# (CellsToCheck.new >> Evaluator.new).(live_cells)
