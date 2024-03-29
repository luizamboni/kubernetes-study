class CreateClickStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :click_statistics do |t|
      t.references :link, null: false, foreign_key: true
      t.date :period
      t.integer :occurences

      t.timestamps
    end
  end
end
