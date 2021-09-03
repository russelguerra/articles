class Article < ApplicationRecord
    # include Visible
    belongs_to :user
    has_many :comments, dependent: :destroy
    
    validates :title, presence: true
    validates :body, presence: true
    validates :user_id, presence: true

    def self.search_by(search_term)
        where("LOWER(title) LIKE :search_term", search_term: "%#{search_term.downcase}%")
    end
end
