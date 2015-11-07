class QuotesController < ApplicationController

  def add_quote
    if params[:user_token]
      # Find user
      @user = User.find_by_token(params[:user_token])
      @source = Source.find_by_hostname(HostnameParser.parse(params[:url])) || Source.create!(:hostname => HostnameParser.parse(params[:url]), :favicon => URI.unescape(params[:favicon]))

      # We should be all set to create the quote now, let's check:
      if @user && @source

        # Create the quote using the necessary params, user and source data
        @quote = Quote.create_through_bookmarklet(params, @user, @source)

        # Variables for the respond_to do |format|, defined in the if else.
        html = ""
        callback = params[:callback]
        if @quote.save

          @user.board.quotes << @quote
          @tags = @user.unique_tags

          html = render_to_string(:partial => "bookmarklet/content", layout: false, locals: {
            tags: @tags,
            title: "The quote was saved.",
            subtitle: "Adding tags helps you to easily find it again."
          })
        else

          callback = "failed"
          
          html = render_to_string(:partial => "bookmarklet/content", layout: false, locals: {
            tags: nil,
            title: "The quote failed to save.",
            subtitle: "This is most likely an error on our end."
          })
        end

        respond_to do |format|
          format.json { render json: { :html => html, :quote_id => @quote.id }, callback: callback, layout: false }
        end
      end # End of if @user && @source
    end # End of if params[:user_token]
  end # End of add_quote

  def show
    @quote = Quote.find(params[:id])
    @board = @quote.boards.first

    respond_to do |format|
      format.html
      format.json
    end
  end

  def filter
    @search = Search.new(params[:search])
    @board = Board.find(params[:board_id])
    @sources = Source.where(:id => @board.quotes.pluck(:source_id))

    # Fetch the Quotes according to the Search query, Source filters and Tag filters
    @quotes = Quote.in_board(@board).filter_by_text(@search.query).filter_by_source_ids(@search.source_ids)
    if !@search.tag_ids.empty?
      @quotes = @quotes.joins(:tags).merge(Tag.filter_by_ids(@search.tag_ids))
    end

    # Only return uniq entries, no duplicate hits
    @quotes = @quotes.uniq.reverse_order

    if @search.query.empty?
      set_titles("", "All quotes")
    else
      set_titles("", "All quotes containing \"#{@search.query}\"")
    end

    respond_to do |format|
      format.html { render "boards/show" }
    end
  end

  def destroy
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.destroy
        format.html { redirect_to boards_path }
      end
    end
  end
end
