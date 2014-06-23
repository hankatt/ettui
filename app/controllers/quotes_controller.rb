class QuotesController < ApplicationController

    include QuotesHelper

    def remote_create
    # Find user
    @user = User.find_by_token(params[:user_token])

    # Set, or if non existing, create, a source for the quote
    @source = Source.find_by_hostname(url_to_hostname(params[:url])) || Source.create!(:hostname => url_to_hostname(params[:url]), :favicon => params[:favicon])

    # Create a quote and connect it to the created source
    if @user && @source
      @quote = Quote.new(:text => params[:text], :user_id => @user.id, :url => params[:url], :source_id => @source.id)
      @quote.boards << @user.boards.first
      @quote.save
    end

    respond_to do |format|
      if @quote
        data = { :message => "Saved." }
        format.json { render json: data, callback: "status" }
      else
        data = { :message => "Service down." }
        format.json { render json: data, callback: "status" }
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
