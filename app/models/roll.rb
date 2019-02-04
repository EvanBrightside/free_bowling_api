class Roll < ApplicationRecord
  belongs_to :frame, inverse_of: :rolls

  validates :pins, presence: true,
                   numericality: {
                     greater_than_or_equal_to: 0,
                     less_than_or_equal_to: :avaliable_pins
                   }

  def pins_count
    pins == 10 ? '10' : pins.to_s
  end

  def avaliable_pins
    return last_strike if frame.last? && frame.strike?

    return (10 - frame.rolls_total) if one_roll && !frame.strike?

    10
  end

  private

  def one_roll
    frame.rolls.count == 1
  end

  def last_strike
    return 10 if one_roll

    10 - frame.rolls.second.pins
  end
end
