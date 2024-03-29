class AddUniqueIndexToLinkUrlHash < ActiveRecord::Migration[6.0]
  def change
    add_index :links, :url_hash, unique: true
  end
end