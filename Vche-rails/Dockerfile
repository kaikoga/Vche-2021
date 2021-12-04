FROM ruby:3.0.3-slim AS base

# Dockerfile for deployment

ENV LANG=C.UTF-8 \
    RAILS_ENV=production

# install common utilities because slim image
# curl and gnupg is for apt-get install yarn
# wget is for entrykit (wtf)
# libicu-dev is for rugged
RUN apt-get update -qq \
  && apt-get install -y curl gnupg wget libicu-dev \
  && rm -rf /var/lib/apt/lists/*

# install nodejs, yarn, and other libraries
# cmake is for rugged gem
RUN curl https://deb.nodesource.com/setup_12.x | bash \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y nodejs yarn default-mysql-client cmake \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /vche
WORKDIR /vche

# setup bundler
COPY Gemfile Gemfile.lock /vche/

RUN gem install bundler:2.2.32 \
  && bundle config set --local deployment true \
  && bundle config set --local without 'development test'

######################################################################

FROM base AS builder

# install additional utilities becuase slim image (mostly for building rugged, sassc, mysql)
RUN apt-get update -qq \
  && apt-get install -y build-essential g++ pkg-config default-libmysqlclient-dev \
  && rm -rf /var/lib/apt/lists/*

# bundle install
RUN bundle install -j3

# precompile assets
COPY . /vche/
RUN SECRET_KEY_BASE=1 VCHE_ENV=1 bundle exec rake assets:precompile

######################################################################

FROM base AS vche-rails

# install entrykit
ENV ENTRYKIT_VERSION 0.4.0

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

COPY . /vche/
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /vche/vendor/bundle/ /vche/vendor/bundle/
COPY --from=builder /vche/public/packs/ /vche/public/packs/

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server"]

ENTRYPOINT [ \
  "prehook", "ruby -v", "--"]
