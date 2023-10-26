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
    TABLE.reduce(0) do |gathered, (percent, wages)|
      if (wages.second..wages.first).cover?(amount)
        break gathered + (amount - wages.second) * percent
      elsif amount > wages.first
        gathered + (wages.first - wages.second) * percent
      end
    end.floor(2)
  end
end
