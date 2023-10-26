# frozen_string_literal: true

class INSS
  def self.[](amount)
    new.discount(amount)
  end

  private

  def discount(amount)
    reduce = 0

    if amount <= 1045
      return amount * 0.075
    else
      reduce += 1045 * 0.075
    end

    if amount <= 2089.60
      return ((amount - 1045) * 0.09) + reduce
    else
      reduce += 2089.60 * 0.09
    end

    if amount <= 3134.40
      return ((amount - 2089.60) * 0.12) + reduce
    else
      reduce += 3134.40 * 0.12
    end

    if amount <= 6101.06
      ((amount - 3134.40) * 0.14) + reduce
    else
      6101.06 * 0.14
    end
  end
end
