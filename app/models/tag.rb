class Tag < ActiveRecord::Base
  has_and_belongs_to_many :quotes
  has_many :boards, through: :quotes

  validates_presence_of :name
  validates_uniqueness_of :name

  def count_for board
    board.tag_count self
  end
end
