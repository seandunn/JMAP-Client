# JMAP Client

## Installation

```shell
  gem install jmap-client
```

## Introduction

**Currently this gem is incomplete and in a pre-release state.**

JMAP-Client implements the JSON Meta Application Protocol (JMAP).

[The JMAP website](https://jmap.io).

JMAP is a generic protocol for synchronising data, such as mail, calendars, or
contacts between a client and a server. It is optimised for mobile and web
environments and aims to provide a consistent interface to different data
types.

The best place to learn about JMAP is by looking at [the spec](https://jmap.io/spec-core.html)
but below is a brief introduction to get you going.

Most requests to a JMAP server are built up from batched method calls on
a server object.

Each method call is given an id which can be used as a reference to previous
results.

For example, you might query a server to get a set of unread email ids.  Once
you have those ids you could get the emails themselves or the ids of the
threads that hold them.

By batching these calls it's possible achieve all of this in one network
efficient request to the JMAP server.

Where possible it automatically adds required request boiler plate.

## Usage

JMAP-Client aims to provide ruby idiomatic wrapper for building up JMAP requests.
As such it uses snake_case in place of the camelCase of JMAP JSON.

```ruby
  require 'jmap-client'
  
  client = JMAP.new(url: "https://jmap.server.example.com", bearer_token: "API-TOKEN-GENERATED-BY-SERVER")
  
  # Making multiple method calls in the same request.
  response = client.request do |request|
    first_30_emails = Email.query(request) do |query|
      query.add_sort JMAP::Plugins::Core::Comparator.new(
      is_ascending: false, property: "receivedAt"
      )
      query.collapse_threads = true
      query.position = 0
      query.limit = 30
      query.calculate_total = true
    end
    
     first_30_thread_ids = Email.get(request) do |get|
      get.ids = first_30_emails.result(path: "/ids")
      get.properties = [ Email::THREAD_ID ]
    end

    first_30_threads = Thread.get(request) do |get|
      get.ids = first_30_thread_ids.result(path: "/list/*/threadId")
    end

    Email.get(request) do |get|
      get.ids = first_30_threads.result(path: "/list/*/emailIds")
      get.properties = [
        Email::THREAD_ID,
        Email::MAILBOX_IDS,
        Email::KEYWORDS,
        Email::HAS_ATTACHMENT,
        Email::FROM,
        Email::SUBJECT,
        Email::RECEIVED_AT,
        Email::SIZE,
        Email::PREVIEW
      ]
    end
  end
```

## Use with Rails

## Plugins
JMAP-Client supports a plugin system to provide a range of functionality:

  * [ ] JMAP Mail
  * [ ] JMAP Calendars
  * [ ] JMAP Sharing
  * [ ] JMAP Contacts
  * [ ] JMAP Tasks
  * [ ] JMAP Quotas

Plugins should be loaded automatically when you connect to a server based on
the capabilities of the JMAP server.

If required plugins can be loaded manually:

```ruby
  JMAP.plugin("mail")
```

## Development

## Contributing
