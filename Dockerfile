FROM ruby:2.7.2

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

ENV RAILS_ENV=development
ENV SECRET_KEY_BASE=Wa4Kdu6hMt3tYKm4jb9p4vZUuc7jBVFw
WORKDIR /monitofen
COPY Gemfile /monitofen/Gemfile
COPY Gemfile.lock /monitofen/Gemfile.lock
RUN bundle install
RUN rails db:setup

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

