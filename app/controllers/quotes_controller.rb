class QuotesController < ApplicationController

  # GET /quotes
  # GET /quotes.json
  def index
    if session[:user_id]
      @user = User.find(session[:user_id])
    end

    @quotes = @user.boards.first.quotes.where("source_id IN (?)", params[:source_ids])

    #   Differs between queries involving source filtering and ones that don't
    if params[:search] && params[:source_ids]
        @quotes = @user.boards.first.quotes.where("source_id IN (?) AND text LIKE ?", params[:source_ids], "%#{params[:search]}%")
        @search = params[:search] # For highlighting on the results
    elsif params[:search]
        @quotes = @user.boards.first.quotes.where("text LIKE ?", "%#{params[:search]}%")
        @search = params[:search] # For highlighting on the results
    elsif params[:source_ids]
        @quotes = @user.boards.first.quotes.where("source_id IN (?)", params[:source_ids])
    else
        @quotes = @user.boards.first.quotes.all
    end

    # Get a list of all sources for this users quotes
    @sources = Source.where(:id => @user.boards.first.quotes.pluck(:source_id))
    
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @quotes }
    end
  end

  def remote_create
    # Find user
    @user = User.find_by_token(params[:user_token])

    # Set, or if non existing, create, a source for the quote
    @source = Source.find_by_hostname(get_host(params[:url])) || Source.create!(:hostname => url_to_host(params[:url]), :favicon => params[:favicon])

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

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
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
    @id = params[:id]
    @quote = Quote.find(params[:id])
    @quote.destroy

    respond_to do |format|
      format.js
      # format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end
end
