# lenshq server

[![Build Status](https://travis-ci.org/lenshq/lens_server.svg?branch=master)](https://travis-ci.org/lenshq/lens_server)
[![Code Climate](https://codeclimate.com/github/lenshq/lens_server/badges/gpa.svg)](https://codeclimate.com/github/lenshq/lens_server)
[![Test Coverage](https://codeclimate.com/github/lenshq/lens_server/badges/coverage.svg)](https://codeclimate.com/github/lenshq/lens_server/coverage)

## Screenshots

# App requests list
![](doc/images/requests_graph.png)

# Request events
![](doc/images/events_graph.png)

## Software stack

Lens server is a Ruby on Rails application that runs on the following software:

* Ubuntu/Debian/CentOS/RHEL
* Ruby (MRI) 2.2
* [Druid](http://druid.io)
* [Redis](http://redis.io/)
* [PostgreSQL](http://www.postgresql.org/)

## Tests

```sh
COVERAGE=true rspec
```
