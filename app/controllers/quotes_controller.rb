class QuotesController < ApplicationController

    include QuotesHelper

    def add_quote
    # Find user
    @user = User.find_by_token(params[:user_token])

    # Set, or if non existing, create, a source for the quote
    @source = Source.find_by_hostname(url_to_hostname(params[:url])) || Source.create!(:hostname => url_to_hostname(params[:url]), :favicon => URI.unescape(params[:favicon]))

    # Create a quote and connect it to the created source
    if @user && @source
      @quote = Quote.new(:text => URI.unescape(params[:text]), :user_id => @user.id, :url => URI.unescape(params[:url]), :source_id => @source.id)
      @quote.boards << @user.boards.first
      @quote.save
    end

    respond_to do |format|
      if @quote
        data = { :message => "Saved.", :submessage => "Add some tags?", :action => "tags", :qid => @quote.id, :tags => @user.boards.first.owned_tags }
        format.json { render json: data, callback: "status" }
      else
        data = { :message => "Service down.", :submessage => "Update bookmarklet or try later.", :action => "tags" }
        format.json { render json: data, callback: "status" }
      end
    end
  end

  def add_tag
    @board = User.find_by_token(params[:user_token]).boards.first
    @quote = Quote.find(params[:qid])

    @tag = URI.unescape(params[:tag])
    @tags = mergeTags(@quote.tags, @tag)

    @board.tag(@quote, :with => @tags, :on => "tags")

    respond_to do |format|
      if @board.save
        data = { :message => "added!", :submessage => "Close this popup when done.", :tag => @tag, :is_new => params[:is_new] }
        format.json { render json: data, callback: "added" }
      else
        data = { :message => "Tagging failed." }
        format.json { render json: data, callback: "added"}
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
