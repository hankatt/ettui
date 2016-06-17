class TagsController < ApplicationController
  before_action :authorize

  def create
    @quote = Quote.find(params[:quote_id])
    @tag = Tag.find_or_initialize_by(tag_params)

    if @tag.new_record? && @tag.valid?
      @tag.name.downcase!
      @tag.save
    else
      # validations failed so you should let the user know
    end

    # Add it to the quotes set of tags
    @quote.tags << @tag

    redirect_to :back
  end

  def destroy    
    @quote = Quote.find(params[:quote_id])
    @tag = Tag.find(params[:id])

    if @tag.last_instance?
      @tag.destroy
    else
      @quote.tags.delete(@tag)
    end

    redirect_to :back
  end

private
  def tag_params
    params.require(:tag).permit(:name)
  end
end
