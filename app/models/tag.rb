class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :books, through: :tag_maps

  validates :tag_name, uniqueness: true
end
