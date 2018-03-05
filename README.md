# README

# How to run app?

1 Install ruby 2.2.5
2 Instal rubygems 2.4.5.1
3 Instal bundler gem

`gem install bundler -v 1.15.4`

4 Install application dependencies

`bundle install`

5 Install postgres server -> version 9.4.4.1
6 Setup app's database

`bundle exec rake db:setup`

7 Run the application in your desire port

`bundle exec rails server -p $PORT`

example:

`bundle exec rails server -p 4000`