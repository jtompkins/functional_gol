class Cell
  DIRECTIONS = [:u, :d, :l, :r, :ul, :ur, :dl, :dr].freeze

  def self.from(cell, at: nil)
    case at
    when :u
      new(cell.x, cell.y - 1)
    when :d
      new(cell.x, cell.y + 1)
    when :l
      new(cell.x - 1, cell.y)
    when :r
      new(cell.x + 1, cell.y)
    when :ul
      new(cell.x - 1, cell.y - 1)
    when :ur
      new(cell.x + 1, cell.y - 1)
    when :dl
      new(cell.x - 1, cell.y + 1)
    when :dr
      new(cell.x + 1, cell.y + 1)
    else
      new(cell.x, cell.y)
    end
  end

  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_reader :x, :y

  def ==(other)
    other.x == x && other.y == y
  end

  alias_method :eql?, :==

  def hash
    [x, y].hash
  end
end

class LiveCell < Cell; end
class DeadCell < Cell; end
