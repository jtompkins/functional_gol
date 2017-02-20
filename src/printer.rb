class Printer
  def call(cells)
    x_range = Range.new(*cells.minmax_by(&:x).map(&:x))
    y_range = Range.new(*cells.minmax_by(&:y).map(&:y))

    x_range.each do |x|
      y_range.each do |y|
        print cells.include?(LiveCell.new(x, y)) ? 'X' : '.'
      end
      puts
    end
  end
end
