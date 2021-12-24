FROM ruby:3.0.3
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
RUN apt update && apt install -y nodejs 
COPY Gemfile Gemfile.lock .
RUN bundle install
COPY . .
ENTRYPOINT ["rails", "server"]
