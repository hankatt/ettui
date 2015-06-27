class Source < ActiveRecord::Base
  has_many :quotes

  def count_for board
    board.source_count self
  end
end
