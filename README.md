# README

[See API documentations](https://followers-api.herokuapp.com/)

# Features

  - User connections
  - Subscribe / Unsubscribe
  - Block / Unblock user from updates

### Tech

Dillinger uses a number of open source projects to work properly:

* [Ruby] - Dynamic, reflective, object-oriented, general-purpose programming language
* [Ruby on Rails] - A server-side web application framework written in Ruby
* [Rubygems] - The platform indicates the gem only works with a ruby built for the same platform
* [ApipieRails] - Ruby on Rails API documentation tool
* [Heroku] - A platform as a service (PaaS) that enables developers to build, run, and operate applications entirely in the cloud.

### Installation

How to [Install Rails](http://installrails.com/)

```sh
$ git clone REPOSITORY
$ cd project
$ bundle install
$ rake db:create && rake db:migrate
$ rails s
```

### Run Unit Testing

```sh
$ cd project
$ bundle exec rspec spec/
```

#### Expected
```
............................

Finished in 2.57 seconds (files took 6.31 seconds to load)
28 examples, 0 failures

Coverage report generated for RSpec to /home/yana/Documents/my_job/followers-api/coverage. 130 / 145 LOC (89.66%) covered.
```
