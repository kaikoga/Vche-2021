FROM ruby:2.7.4

# Dockerfile for deployment

ENV LANG=C.UTF-8 \
    RAILS_ENV=production

# install nodejs, yarn, and other libraries
# cmake is for rugged gem
RUN curl https://deb.nodesource.com/setup_12.x | bash \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn default-mysql-client cmake \
  && rm -rf /var/lib/apt/lists/*

# install entrykit
ENV ENTRYKIT_VERSION 0.4.0

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

RUN mkdir /vche
WORKDIR /vche

COPY Gemfile Gemfile.lock /vche/

RUN gem install bundler:2.2.24 \
  && bundle config set --local deployment true \
  && bundle config set --local without 'development test'

RUN bundle install -j3

COPY . /vche/

# FIXME: at least get rid of node_modules, possibly multi-stage build?
RUN SECRET_KEY_BASE=1 bundle exec rake assets:precompile

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

ENTRYPOINT [ \
  "prehook", "ruby -v", "--"]
