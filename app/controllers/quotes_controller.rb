class QuotesController < ApplicationController

  include QuotesHelper

  def add_quote
    if params[:user_token]
      # Find user
      @user = User.find_by_token(params[:user_token])

      # Set, or if non existing, create, a source for the quote
      # @source = Source.find_or_create_by(:hostname => url_to_host_name(params[:url], :favicon => URI.unescape(params[:favicon])))
      @source = Source.find_by_hostname(url_to_hostname(params[:url])) || Source.create!(:hostname => url_to_hostname(params[:url]), :favicon => URI.unescape(params[:favicon]))

      # Create a quote and connect it to the created source
      if @user && @source

        # URL to parse with the Parser API
        readability_response = ReadabilityParser.parse_url(params[:url])
        readability_title = readability_response["title"]
        readability_author = parreadability_responsesed["readability_response"]

        # Validate that it is just the author
        # Assume most names won't use more than 4 names tops
        # Assume most names won't be that long, 34 chars tops
        if readability_author.nil? || readability_author.scan(/\w+/).size > 4 || readability_author.length > 34
          readability_author = nil
        end

        # Build quote to save
        @quote = @user.boards.first.quotes.new({
          :text => URI.unescape(params[:text]), 
          :url => URI.unescape(params[:url]), 
          :readability_title => readability_title,
          :readability_author => readability_author,
          :source_id => @source.id
        })
      end
    end

    respond_to do |format|
      if @quote.save
        data = { 
          :message => "The quote was saved.", 
          :submessage => "Adding tags help you to easily find it again.",
          :quote => @quote.to_json(include: :tags),
        }

        format.json { render json: data, callback: "success" }
      else
        data = {
          :message => "Could Not save the quote.",
          :submessage => "Please try again later.",
        }

        format.json { render json: data, callback: "fail" }
      end
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @board = @quote.boards.first

    respond_to do |format|
      format.html
      format.json
    end
  end

  def filter
    @search = Search.new params[:search]
    @board = Board.find(params[:board_id])

    # Post.where(published: true).joins(:comments).merge( Comment.where(spam: false) )

    @quotes = Quote.in_board(@board).filter_by_text(@search.query).filter_by_source_ids(@search.source_ids).joins(:tags).merge(Tag.filter_by_ids(@search.tag_ids))

    @sources = Source.where(:id => @board.quotes.pluck(:source_id))
    @unread = []
    respond_to do |format|
      format.html { render "boards/show" }
      #format.json { render json: @quotes }
    end
  end

end
