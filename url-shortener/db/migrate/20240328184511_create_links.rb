class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :url_hash
      t.string :url

      t.timestamps
    end
  end
end
