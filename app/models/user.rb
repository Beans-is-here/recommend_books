class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :books, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_books, through: :bookmarks, source: :book
  has_many :hasreads, dependent: :destroy
  has_many :hasread_books, through: :hasreads, source: :book

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 4 }, confirmation: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  def own?(object)
    id == object&.user_id
  end
  
  def bookmark(book)
    bookmark_books << book
  end

  def unbookmark(book)
    bookmark_books.destroy(book)
  end

  def bookmark?(book)
    bookmark_books.include?(book)
  end

  def hasread(book)
    hasread_books << book
  end

  def unhasread(book)
    hasread_books.destroy(book)
  end

  def hasread?(book)
    hasread_books.include?(book)
  end
end