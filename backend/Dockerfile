FROM ruby:2.6
RUN apt-get update -qq
RUN mkdir /ship_sticks_dev_challenge
WORKDIR /ship_sticks_dev_challenge
COPY Gemfile /ship_sticks_dev_challenge/Gemfile
COPY Gemfile.lock /ship_sticks_dev_challenge/Gemfile.lock
RUN bundle install
COPY . /ship_sticks_dev_challenge

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
