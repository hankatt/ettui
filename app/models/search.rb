class Search
  include ActiveModel::Model

  attr_accessor :query, :tag_ids, :source_ids

  def query
    @query || ""
  end

  def tag_ids
    @tag_ids || []
  end

  def source_ids
    @source_ids || []
  end

  def update_params_for(param)
    if param.is_a?(Tag)
      update_params_for_tag(param)
    elsif param.is_a?(Source)
      update_params_for_source(param)
    end
  end

  def source_classes source
    classes = ["source"]
    classes << "is-active" if source_ids.include?(source.id.to_s)
    classes.join(" ")
  end

  def tag_classes tag
    classes = ["c-tag"]
    classes << "is-active" if tag_ids.include?(tag.id.to_s)
    classes.join(" ")
  end

  def empty?
    query.empty? && tag_ids.empty? && source_ids.empty?
  end

private
  def update_params_for_tag(tag)
    # Rails.logger.debug("KLLKJLKJLKJLKJLKJLKJKJLKJ #{tag_ids}")
    # Rails.logger.debug("#{tag.id.to_s} IS IN tag_ids: #{tag_ids.include?(tag.id.to_s)}")
    if tag_ids.include?(tag.id.to_s)
      # deselect tag
      reverse_merge(to_params, {"search"=>{"tag_ids"=>[tag.id.to_s]}})
    else
      # select tag
      merge(to_params, {"search"=>{"tag_ids"=>[tag.id.to_s]}})
    end
  end

  def update_params_for_source(source)
    if source_ids.include?(source.id.to_s)
      # deselect tag
      reverse_merge(to_params, {"search"=>{"source_ids"=>[source.id.to_s]}})
    else
      # select tag
      merge(to_params, {"search"=>{"source_ids"=>[source.id.to_s]}})
    end
  end

  def merge(h1,h2)
    # Hannes haxxxxxx
    h1.deep_merge(h2) do |key, v1, v2|
      if (v1.respond_to?(:+) && v2.respond_to?(:+))
        # the values are arrays so we merge them
        v1 + v2
      else
        # replace value in h1 with value in h2
        v2
      end
    end
  end

  def reverse_merge(h1,h2)
    # Hannes haxxxxxx
    h1.deep_merge(h2) do |key, v1, v2|
      if (v1.respond_to?(:+) && v2.respond_to?(:+))
        # the values are arrays so we merge them
        # we now deselect everything but the tag we want to deselect
        Rails.logger.debug("removing #{v1} from #{v2}")
        v1 - v2
      else
        # replace value in h1 with value in h2
        v2
      end
    end
  end

  def to_params
    {
      "search" => {
        "query"=> query,
        "tag_ids" => tag_ids,
        "source_ids" => source_ids
      }
    }
  end
end
