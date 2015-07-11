# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

password_salt = BCrypt::Engine.generate_salt
password_hash = BCrypt::Engine.hash_secret("test", password_salt)
demo_user = User.find_or_create_by({
  email: "board@ettui.com",
  password_salt: password_salt,
  password_hash: password_hash,
  twitter_image_url: "https://randomuser.me/api/portraits/med/women/24.jpg",
  last_active_at: DateTime.now
})

demo_user.save(validate: false)

def encrypt_password(password)
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
end

sources = [{
  hostname: "alistapart.com",
  favicon: "http://alistapart.com/components/assets/img/favicons/favicon.ico"
}, {
  hostname: "nytimes.com",
  favicon: "http://static01.nyt.com/favicon.ico"
}, {
  hostname: "thegreatdiscontent.com",
  favicon: "http://thegreatdiscontent.com/favicon.ico"
}].map do |source|
  Source.find_or_create_by(source)
end

alistapart = sources[0]
alistapart.quotes.create({
  "text"=>"Whether in a leadership role as the cultural advocate, or as a passionate and dedicated member of the team, we can agree: a happy and well-supported employee is a fueled, charged, inspired worker.",
  "url"=>"http://alistapart.com/article/resetting-agency-culture#!",
  "user_id"=>demo_user.id
})

nytimes = sources[1]
nytimes.quotes.create({
  "text"=>"In a long-sought victory for the gay rights movement, the Supreme Court ruled by a 5-to-4 vote on Friday that the Constitution guarantees a right to same-sex marriage.",
  "url"=>"http://www.nytimes.com/2015/06/27/us/supreme-court-same-sex-marriage.html?_r=0",
  "user_id"=>demo_user.id
})

tgd = sources[2]
tgd.quotes.create({
  "text"=>"“…in order to make it, you have to be really ambitious. Talent without ambition is nothing; you have to drive yourself to make things. And it’s the same thing with creativity: if you have a lot of ambition without creativity, you might not go anywhere.”",
  "url"=>"https://thegreatdiscontent.com/interview/jacob-escobedo",
  "user_id"=>demo_user.id
})

tags = [{
  name: "design"
  }, {
  name: "news"
  }, {
  name: "process"
  }, {
  name: "leadership"
  }].map do |tag|
    Tag.find_or_create_by(tag)
end

alistapart.quotes.first.tags.push(tags[0, 3])
nytimes.quotes.first.tags.push(tags[1])
tgd.quotes.first.tags.push(tags[0, 2])

quotes = []
quotes.push(alistapart.quotes)
quotes.push(nytimes.quotes)
quotes.push(tgd.quotes)

demo_user.boards.first.quotes << quotes 
