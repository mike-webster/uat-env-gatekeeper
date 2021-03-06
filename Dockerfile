FROM ruby:2.5-alpine3.8

WORKDIR /uat-env-gatekeeper

RUN apk update && \
    apk add --no-cache \
        ca-certificates \
	    tzdata \
        curl \
	    mysql-client 

RUN gem update --system && gem install bundler

ENV RAILS_ENV=production
ENV BOT_TOKEN="" 
ENV GATEKEEPER="" 
ENV ADMINS=[""] 
ENV SLACK_DOMAIN="" 
ENV HOST="" 
ENV DB_USER="" 
ENV DB_PASS=""
ENV SECRET_KEY_BASE=""

RUN apk add --no-cache \
        nodejs \
        git  \
        file \
        yarn \
        bash \ 
        libxml2-dev \
        libxslt-dev \
        freetds-dev \
        alpine-sdk \
        mariadb-dev

COPY Gemfile* /uat-env-gatekeeper/

RUN bundle install --jobs=4 --without development test

COPY . /uat-env-gatekeeper

RUN bundle exec rake assets:precompile

EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "rails", "db:create", "db:migrate", "start_server"]