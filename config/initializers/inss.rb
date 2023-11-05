# frozen_string_literal: true

class INSS
  TABLE = {
    0.075 => [1045, 0],
    0.09 => [2089.60, 1045],
    0.12 => [3134.40, 2089.60],
    0.14 => [6101.06, 3134.40]
  }

  def self.[](amount)
    amount = amount.to_f
    TABLE.reduce([0, 0]) do |result, (ratio, wages)|
      if (wages.second..wages.first).cover?(amount)
        break (result.first + (amount - wages.second) * ratio).floor(2), ratio
      elsif amount > wages.first
        [(result.first + (wages.first - wages.second) * ratio).floor(2), ratio]
      end
    end
  end
end
