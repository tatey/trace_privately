# HTTP Key Server for TracePrivately

This is a sample HTTP key server for the sample [TracePrivately app](https://github.com/CrunchyBagel/TracePrivately). Development is moving fast and this is a work-in-progress. If you want to help take a look at the [Issues](https://github.com/tatey/trace_privately/issues).

# Objectives

- Be a robust companion to the [TracePrivately app](https://github.com/CrunchyBagel/TracePrivately)
- Create a fully-functioning prototype that governments can use as an almost-turnkey solution that they can rebrand as necessary and use
- Implement correct security and privacy principles to maximise uptake of said government apps
- Remain open source for independent verification
- Tools for moderating submissions and exporting data in open formats
- Work in a localized manner so it can be used in any language or jurisdiction

## System Dependencies

For running or developing the app:

- [Ruby](https://www.ruby-lang.org/) 2.6.6
- [Bundler](https://bundler.io/)
- [Node](https://nodejs.org/) 13+
- [Yarn](https://yarnpkg.com/)
- [PostgreSQL](https://www.postgresql.org) 10+ (Can be substituted for any database supported by Ruby on Rails)

For developing the app:

- [Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)

## Setup

The setup script will install the app's dependencies and prepare the database.

    $ ./bin/setup

Run the test suite to see if everything is working correctly.

    $ ./bin/rails test
    $ ./bin/rails test:system

Start the server on port 3000 and begin receiving requests:

    $ ./bin/rails server --port 3000

## Usage

### Admin

View recent submissions and confirm test results.

![Screenshot of a list of submissions](doc/screenshots/admin_index.png?raw=true)
![Screenshot of an individual submission](doc/screenshots/admin_show.png?raw=true)

### API

Get a list of infected keys since a specific time (Limited to 30 days ago):

    $ curl -s -v -X GET -H "Accept: application/json" "http://localhost:3000/api/infected?since=2020-04-19T00:00:00Z" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK",
      "date": "2020-04-19T01:02:20Z",
      "keys": [
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEz",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEy",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEx",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEw",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2Xzk=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2Xzg=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2Xzc=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzY=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzU=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzQ=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzM=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzI=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzE=",
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzA="
      ],
      "deleted_keys": [
        "RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzEz"
      ]
    }

Submit infected keys:

    $ curl -s -v -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d '{"keys":["RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzI="]}' "http://localhost:3000/api/submit" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK"
      "identifier": "21532f3e-461d-4cb5-9304-602936757bc7"
    }

## License

This app is available as open source under the terms of the MIT License. See LICENSE.
