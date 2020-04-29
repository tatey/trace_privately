# Key Server for TracePrivately

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

A robust and fully featured key server for the [TracePrivately iOS app](https://github.com/CrunchyBagel/TracePrivately). Based on the Apple/Google (COVID-19) Exposure Framework.

## Table of Contents

- [Objectives](#goals)
- [Security](#security)
- [Admin](#admin)
- [API](#api)
- [Developing or Hosting the Key Server](#developing-or-hosting-the-key-server)
- [License](#license)

## Objectives

- Be a robust companion to the [TracePrivately app](https://github.com/CrunchyBagel/TracePrivately)
- Create a fully-functioning prototype that governments can use as an almost-turnkey solution that they can rebrand as necessary and use
- Tools for government agents or health professionals to manage submissions
- Implement correct security, privacy, and testing principles to maximise uptake of said government apps
- Remain open source for independent verification
- Work in a localized manner so it can be used in any language or jurisdiction

## Security

- Non-HTTP requests will be redirected to HTTPS. (See config/production.rb)
- Noisy clients will be rate limited. (See config/initializers/rack_attack.rb)
- Authentication tokens expire after 7 days and can be revoked at any time.
- Submissions and their infected keys expire after 30 days.
- A daily task can be scheduled to to destroy expired submissions and expired authentication tokens.
- A submission needs to be confirmed before it's keys are included in the list of infected keys.
- No personal information is stored in the database or in the logs, including the client's IP addresses. (See config/application.rb and config/initializers/rack_attack.rb)
- TODO: The admin section is protected with two factors of authentication. (See https://github.com/tatey/trace_privately/issues/20)
- TODO: The API verifies the client is from a genuine installation of the TracePrivately app using the DeviceCheck API. (See https://github.com/tatey/trace_privately/issues/19)
- Plus all the [protections you get built-in](https://guides.rubyonrails.org/security.html) from using Ruby on Rails.

## Admin

Government agents or helth professionals can view recent submissions and confirm test results.

![Screenshot of a list of submissions](doc/screenshots/admin_index.png?raw=true)
![Screenshot of an individual submission](doc/screenshots/admin_show.png?raw=true)

## API

Request an authentication token (Tokens expire after 7 days):

    $ curl -s -v -X POST -H "Accept: application/json" "http://localhost:3000/api/auth" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK",
      "token": "wXxgbZ8ztwZS5woTgpsBzNwY",
      "expires_at": "2020-05-03T12:25:11Z"
    }

Get a list of infected keys since a specific time (Limited to 30 days ago):

    $ curl -s -v -X GET -H "Authorization: Bearer c6rxEAhRcWSh2y8WSF1bYwgA" -H "Accept: application/json" "http://localhost:3000/api/infected?since=2020-04-19T00:00:00Z" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK",
      "date": "2020-04-28T10:26:29Z",
      "keys": [
        {
          "d": "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEz",
          "r": 1
        },
      ],
      "deleted_keys": [
        {
          "d": "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEy",
          "r": 2
        }
      ]
    }

Submit infected keys:

    $ curl -s -v -X POST -H "Authorization: Bearer wXxgbZ8ztwZS5woTgpsBzNwY" "Accept: application/json" -H "Content-Type: application/json" -d '{"keys":[{"d":"RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzI=","r":1234}]}' "http://localhost:3000/api/submit" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK",
      "identifier": "21532f3e-461d-4cb5-9304-602936757bc7"
    }

## Developing or Hosting the Key Server

### System Dependencies

For running or developing the app:

- [Ruby](https://www.ruby-lang.org/) 2.6.6
- [Bundler](https://bundler.io/)
- [Node](https://nodejs.org/) 13+
- [Yarn](https://yarnpkg.com/)
- [PostgreSQL](https://www.postgresql.org) 10+ (Can be substituted for any database supported by Ruby on Rails)
- [Redis](https://redis.io) 5+

For developing the app:

- [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)

### Developing on your computer

The setup script will install the app's dependencies and prepare the database.

    $ ./bin/setup

Run the test suite to see if everything is working correctly.

    $ ./bin/rails test
    $ ./bin/rails test:system

Start the server on port 3000 and begin receiving requests:

    $ ./bin/rails server --port 3000

Destroy all expired submissions and expired access grants:

    $ ./bin/rails db:prune

## License

This software is available as open source under the terms of the MIT License. See LICENSE.
