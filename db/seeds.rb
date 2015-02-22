# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create a board
board = User.first.boards.first
google = Source.create hostname: "test.google.com", favicon: "http://www.google.com/favicon.ico"
aftonhoran = Source.create hostname: "test.aftonhoran.com", favicon: "http://www.aftonbladet.se/favicon.ico"

# Create instances of quotes and tags
2.times { |index| Quote.create text: "This quote is #{index} times better than the last one.", url: "http://www.google#{index}.com", source_id: google.id }
2.times { |index| Quote.create text: "This afton is #{index} times horigare than the last one.", url: "http://www.aftonhoran#{index}.com", source_id: aftonhoran.id }

tags = []
tags << "Design" << "Katt" << "Husdjur" << "Bostad" << "Internet" << "Kalas" << "Programmering" << "Skola" << "Apple" << "Kaffe"

10.times { |index| Tag.create name: tags[index] }

# Fetch the quotes we created
quotes = Quote.limit(4)

quotes.each_with_index do |quote, index|
	# Add some tags
	quote.tags << Tag.find(rand(1..10))
	quote.tags << Tag.find(rand(1..10))

	# Add to board
	board.quotes << quote
end

