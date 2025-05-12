class Book < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :hasreads, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  validates :title, presence: true

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
    ["title", "description"]
  end

  def create_tags(input_tags)
    puts "Created tags: #{tags.pluck(:tag_name).join(', ')}"
    input_tags.each do |tag_name|
      tag = Tag.find_or_create_by(tag_name: tag_name)
      tag_maps.create(tag: tag)
    #  tags << tag
      puts "Associated tags: #{tags.pluck(:tag_name).join(', ')}"
      puts "Current tags associated: #{self.tags.pluck(:tag_name).join(', ')}"
    end
  end

  def update_tags(input_tags)
    registered_tags = tags.pluck(:tag_name)
    new_tags = input_tags - registered_tags
    destroy_tags = registered_tags - input_tags

    new_tags.each do |tag|
      new_tag = Tag.find_or_create_by(tag_name: tag)
      tags << new_tag
    end

    destroy_tags.each do |tag|
      tag_id = Tag.find_by(tag_name: tag)
      destroy_tag_map = TagMap.find_by(tag_id: tag_id, book_id: id)
      destroy_tag_map.destroy
    end
  end
end
