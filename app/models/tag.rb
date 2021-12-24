class Tag < ActiveRecord::Base
  has_and_belongs_to_many :quotes
  has_many :boards, through: :quotes

  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :is_new, :is_existing

  def self.filter_by_ids(ids)
    if ids.empty?
      all.distinct # We don't know why we need to run .uniq here but if not, we get duplicates or triplets or worse.
    else
      where(id: ids)
    end
  end

  def is_new?
    if new_record? && valid?
      return save # Create the tag since it is new, returns true if added properly
    else
      return false
    end
  end

  def count_for board
    board.tag_count self
  end

  def last_instance?
    quotes.count == 1
  end
end
