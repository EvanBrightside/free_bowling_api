class CreateRolls < ActiveRecord::Migration[5.2]
  def change
    create_table :rolls do |t|
      t.belongs_to :frame, foreign_key: true, null: false
      t.integer    :pins, null: false
      t.integer    :bonus_score, default: 0

      t.timestamps
    end
  end
end
