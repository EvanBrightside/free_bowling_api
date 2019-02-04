class Api::GameSerializer < ActiveModel::Serializer
  attributes :id, :total_score, :rolls_total

  def total_score
    object.total_score
  end

  def rolls_total
    if object.frames.present?
      object.frames.each_with_index.map do |x, i|
        ["frame: #{i + 1} | score: #{x.rolls_total}"]
      end
    else
      0
    end
  end
end
