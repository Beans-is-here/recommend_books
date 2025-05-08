class Book < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :hasreads, dependent: :destroy

  def self.create_all_ranks
    Book.joins(:hasreads)
        .group(:id)
        .order('count(hasreads.id) desc')
        .limit(5)
  end

  def self.create_all_ranks
    Book.joins(:hasreads)
        .select('books.*, count(hasreads.id) as hasread_count')
        .group('books.id')
        .order('hasread_count desc')
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["title"]
  end

end
