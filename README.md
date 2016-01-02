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

## TODO

* [x] EHLO
* [x] HELO
* [x] MAIL verb
* [x] RCPT verb
* [x] RSET verb
* [x] STARTTLS
* [x] Renegotiate SSL on RSET
* [x] Assign session ID as soon as session starts
* [ ] plain & html body parsing
* [ ] AUTH
* [ ] CHUNKING
* [ ] PIPELINING
* [ ] SPF records
* [ ] MX verification
* [ ] 8BITMIME
* [ ] Support for "EHLO <>" and "EHLO <FQDN>"


## WIP notes

* start_ranch stuff should actually be in a supervisor
* cache the DNS records for atleast 3 minutes in ETS
* If user authenticates, then it's an outgoing email (to be relayed to another server). Else it is incoming mail to accept.
* Check relaying mail if it is destined for the same (self) email server.

>  When the RFC 822 format ([28], [4]) is being used, the mail data
   include the header fields such as those named Date, Subject, To, Cc,
   and From.  Server SMTP systems SHOULD NOT reject messages based on
   perceived defects in the RFC 822 or MIME (RFC 2045 [21]) message
   header section or message body.  In particular, they MUST NOT reject
   messages in which the numbers of Resent-header fields do not match or
   Resent-to appears without Resent-from and/or Resent-date.

* Perform recipient verification only after the whole mail transaction is complete (email bouncing)

* Should prepend a "Received" header with mandatory protocol in the via clause.
example: "from [ClientIP] by [self-ip] via SMTP, [date]"


* 421 response if need to shutdown SMTP service
* EHLO with address literal for clients or FQDN for relays
  * size
  * extension list
* What happens to Bcc emails? Are they sent the 2nd time or single copy?


## RFCs

* [RFC 5321](https://tools.ietf.org/html/rfc5321) SMTP
* [RFC 822](https://tools.ietf.org/html/rfc822) Standard for ARPA Internet Text Messages
* [RFC 7504](https://tools.ietf.org/html/rfc7504) SMTP 521 and 556 reply codes
* [RFC 6409](https://tools.ietf.org/html/rfc6409) Message Submission for Mail
* [RFC 4954](https://tools.ietf.org/html/rfc4954) SMTP Service Extension for Authentication
* [RFC 6152](https://tools.ietf.org/html/rfc6152) 8BITMIME extension

* [RFC 5322](https://tools.ietf.org/html/rfc5322) Internet Message Format
* [RFC 2045](https://tools.ietf.org/html/rfc2045) MIME

## To test things out on command line

```
# For a plain connection
telnet localhost 2525

# To use STARTTLS
openssl s_client -starttls smtp -crlf -connect localhost:2525
```

Replace port as necessary. 2525 is the default Ennio port.
