FROM ruby:3.2.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client tree
WORKDIR /kosa
COPY Gemfile /kosa/Gemfile
COPY Gemfile.lock /kosa/Gemfile.lock
RUN bundle install

COPY docker/apiserver/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
COPY . /kosa/
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]