# Ennio

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ennio to your list of dependencies in `mix.exs`:

        def deps do
          [{:ennio, "~> 0.0.1"}]
        end

  2. Ensure ennio is started before your application:

        def application do
          [applications: [:ennio]]
        end

## WIP notes

* Ranch delays accepting connections if the OS runs out of file descriptors
* Limit the amount of bytes that a connection can accept. Else sending data repeatedly to keep a connection open can cause blocks.

* start_ranch stuff should actually be in a supervisor
* :inet_res.lookup('hashnuke.com', :in, :mx) to lookup MX records
* cache the DNS records for atleast 3 minutes in ETS
* If user authenticates, then it's an outgoing email (to be relayed to another server). Else it is incoming mail to accept.
* Check relaying mail if it is destined for the same (self) email server.

## RFCs

* [RFC 5321](https://tools.ietf.org/html/rfc5321) - SMTP
* [RFC 7504](https://tools.ietf.org/html/rfc7504) - SMTP 521 and 556 reply codes
