FROM ruby:2.1.2
RUN apt-get update -qq && apt-get install -y build-essential nodejs mysql-client vim
RUN mkdir /epicvotes

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /epicvotes
WORKDIR /epicvotes
CMD ["rails","server","-b","0.0.0.0"]