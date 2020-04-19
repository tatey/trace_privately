# HTTP Key Server for TracePrivately

This is a sample HTTP key server for the sample [TracePrivately app](https://github.com/CrunchyBagel/TracePrivately).

## System Dependencies

- [Ruby](https://www.ruby-lang.org/) 2.6.5
- [Bundler](https://bundler.io/)
- [Node](https://nodejs.org/) 13+
- [Yarn](https://yarnpkg.com/)
- [SQLite](https://sqlite.org/) 3+ (Can be substituted for any database supported by Ruby on Rails)

## Setup

The setup script will install the application's dependencies and prepare the database.

    $ ./bin/setup

Start the server on port 3000 and begin receiving requests:

    $ ./bin/rails server --port 3000

## Usage

Get a list of infected keys since a specific time:

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
      ]
    }

Submit infected keys:

    $ curl -s -v -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d '{"keys":["RDgwNjlEM0EtMzU2OC00MzY4LTkzRjAtQTA4MzVFNkREQjI2XzI="]}' "http://localhost:3000/api/submit" | jq
    < HTTP/1.1 200 OK
    < Content-Type: application/json; charset=utf-8
    {
      "status": "OK"
    }

## License

The software is available as open source under the terms of the MIT License. See LICENSE.
