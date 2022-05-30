FROM ruby:2.7.2

RUN curl https://deb.nodesource.com/setup_14.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

WORKDIR /monitofen
COPY . .
RUN bundle install
RUN yarn install --frozen-lockfile
RUN RAILS_ENV=production SECRET_KEY_BASE=Wa4Kdu6hMt3tYKm4jb9p4vZUuc7jBVFw rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

