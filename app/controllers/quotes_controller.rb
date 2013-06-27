class QuotesController < ApplicationController

  include QuotesHelper

  # GET /quotes
  # GET /quotes.json
  def index
    if cookies[:user_id]
      @user = User.find(cookies[:user_id])
    end

    @quotes = Quote.where("user_id" => @user.id).search(params[:search])
    @source_counts = Quote.group("source_id").where("user_id" => @user.id).count
    @sources = Source.find_all_by_id(@source_counts.keys)
    # Sorted DESC based on count 
    # @source_counts = Quote.group("source_id").where("user_id" => 21).order("count_source_id DESC").count(:source_id)
    
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
    @source = Source.find_by_hostname(get_host(params[:url])) || Source.create!(:hostname => get_host(params[:url]), :favicon => params[:favicon])

    # Create a quote and connect it to the created source
    if @user && @source
      @quote = Quote.create!(:text => params[:text], :user_id => @user.id, :url => params[:url], :source_id => @source.id)
    end

    respond_to do |format|
      if @quote
        data = { :message => "Saved!" }
        format.json { render json: data, callback: "status" }
      else
        data = { :message => "Try again." }
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

  # GET /quotes/new
  # GET /quotes/new.json
  def new
    @quote = Quote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(params[:quote])

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render json: @quote, status: :created, location: @quote }
      else
        format.html { render action: "new" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
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

  def search
    @quotes = Quote.search(params[:search])

    respond_to do |format|
        format.js
        format.json { head :no_content }
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
