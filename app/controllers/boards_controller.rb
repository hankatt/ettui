class BoardsController < ApplicationController
  before_action :authorize

  def show
    @search = Search.new(params[:search])
    @board = Board.find(params[:id])
    @sources = Source.where(id: @board.quotes.pluck(:source_id))

    # Fetch the Quotes according to the Search query, Source filters and Tag filters
    @quotes = Quote.in_board(@board).filter_by_text(@search.query).filter_by_source_ids(@search.source_ids)
    if !@search.tag_ids.empty?
      @quotes = @quotes.joins(:tags).merge(Tag.filter_by_ids(@search.tag_ids))
    end

    # Only return uniq entries, no duplicate hits
    @quotes = @quotes.uniq.reverse_order

    if @search.query.empty?
      @left_title = ""
      @quotes_container_title = "All quotes"
    else
      @left_title = ""
      @quotes_container_title = "All quotes containing \"#{@search.query}\""
    end
  end
end
