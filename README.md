# README

[See API documentations](https://followers-api.herokuapp.com/)

# Features

  - Friend connections
  - Subscribe
  - Block / Ublock user from updates

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
...............................

Finished in 1.6 seconds (files took 1.9 seconds to load)
31 examples, 0 failures

Coverage report generated for RSpec to /Users/apple/Documents/HomeWork/friend_management_api/coverage. 165 / 179 LOC (92.18%) covered.
```
