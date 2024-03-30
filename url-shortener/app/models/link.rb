class Link < ApplicationRecord
  before_save :generate_url_hash

  has_many :click_statistics, dependent: :destroy  
  has_many :clicks, dependent: :destroy  

  validates :url_hash, uniqueness: true

  broadcasts_to -> (link) { :links }

  private
  def generate_url_hash
    loop do
        self.url_hash = SecureRandom.alphanumeric(7)
        break unless Link.exists?(url_hash: url_hash)
    end
  end
end
