FROM ruby:3.1.1

RUN apt-get update -qq && \
    apt-get install -y build-essential libssl-dev libpq-dev less vim nano libsasl2-dev

ENV WORK_ROOT /src
ENV APP_HOME $WORK_ROOT/myapp/
ENV LANG C.UTF-8
ENV GEM_HOME $WORK_ROOT/bundle
ENV BUNDLE_BIN $GEM_HOME/gems/bin
ENV PATH $GEM_HOME/bin:$BUNDLE_BIN:$PATH

RUN gem install bundler

RUN mkdir -p $APP_HOME

RUN bundle config --path=$GEM_HOME

WORKDIR $APP_HOME

ADD Gemfile ./
ADD Gemfile.lock ./
RUN bundle install

RUN echo $
ADD . $APP_HOME

EXPOSE 3000


ENTRYPOINT bash -c "rm -f tmp/pids/server.pid && rails db:create && rails db:migrate && bundle exec rails s -b 0.0.0.0 -p 3000"
