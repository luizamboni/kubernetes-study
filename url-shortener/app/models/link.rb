class Link < ApplicationRecord
  before_save :generate_url_hash

  has_many :click_statistics
  
  validates :url_hash, uniqueness: true

  private
  def generate_url_hash
    loop do
        self.url_hash = SecureRandom.alphanumeric(7)
        break unless Link.exists?(url_hash: url_hash)
    end
  end
end
