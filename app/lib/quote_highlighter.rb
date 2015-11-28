class QuoteHighlighter
  def self.hilight(quote, query)
    if quote.text.length > 280
      em_start_index = em_end_index = em_word_count = 0
      em_final_word_count = 4 # Number of words to emphasize
      quote.text.length.times do |i|
        if quote.text.at(i).eql?(" ")
          em_word_count = em_word_count + 1
          if em_word_count.eql?(em_final_word_count)
            em_end_index = i
            break
          end
        end
      end
      quote.text.insert(em_end_index, "</em>")
      quote.text.insert(em_start_index, "<em>")
    end

    if query.eql?("") || query.nil?
      quote.text
    else
      quote.text.gsub(/#{query}/, "<mark>#{query}</mark>")
    end
  end
end
