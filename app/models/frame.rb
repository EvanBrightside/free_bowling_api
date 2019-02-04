class Frame < ApplicationRecord
  belongs_to :game, inverse_of: :frames
  has_many :rolls, inverse_of: :frame

  attr_accessor :score

  def strike?
    rolls.first&.pins == 10
  end

  def spare?
    return false if rolls.to_a.size < 2

    rolls.first.pins + rolls.second.pins == 10
  end

  def rolls_total
    rolls.reduce(0) { |sum, roll| sum + roll.pins + roll.bonus_score }
  end

  def bonus?
    strike? || spare?
  end

  def incomplete?
    !game_over?
  end

  def last?
    game.frames.to_a.size == 10
  end

  private

  def game_over?
    if last?
      max = bonus? ? 3 : 2
      rolls.to_a.size == max
    else
      strike? || rolls.to_a.size == 2
    end
  end
end
