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
