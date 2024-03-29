class CreateClicks < ActiveRecord::Migration[7.1]
  def change
    create_table :clicks do |t|
      t.references :link, null: false, foreign_key: true
      t.string :user_agent

      t.timestamps
    end
  end
end
