class Game < ApplicationRecord
  has_many :frames, inverse_of: :game
  has_many :rolls, through: :frames

  default_scope { includes(:frames, :rolls) }

  def new_roll(pins)
    roll = Roll.new pins: pins
    frame_status(roll)
    roll.errors.to_a
  end

  def total_score
    calculate_scores.nil? ? 0 : calculate_scores
  end

  private

  def frame_status(roll)
    return frames.last.rolls << roll if frames.last&.incomplete?
    return ['Game over'] if frames.to_a.size == 10

    frames << Frame.new(rolls: [roll])
  end

  def calculate_scores
    score = 0
    frames.each do |frame|
      current_score = frame_score(frame)

      break unless current_score

      score = score ? score + current_score : current_score
      frame.score = score
    end
    score
  end

  def frame_score(frame)
    return frame.rolls_total unless frames.count > 1 && frame == frames.last

    bonus_session(frame)
    frame.rolls_total
  end

  def bonus_session(frame)
    if frames[-2].strike?
      return frame.rolls_total if frame.rolls.second.nil? && !frame.strike?

      upd_bonus_score(frame.rolls_total)
    elsif frames[-2].spare? && frame.rolls.count == 1
      upd_bonus_score(frame.rolls.first.pins)
    end
  end

  def upd_bonus_score(amount)
    bonus_score = frames[-2].rolls.first.bonus_score
    frames[-2].rolls.first.update!(bonus_score: amount) if bonus_score.zero?
  end
end
