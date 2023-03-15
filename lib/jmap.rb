# frozen_string_literal: true

require "zeitwerk"
require "jmap/core/client"
require "jmap/core/invocation"
require "jmap/core/request"
require "jmap/core/response"
require "jmap/core/session"
require "jmap/mail/mailbox"

Zeitwerk::Loader.for_gem.setup

module JMAP
  # For methods params that default to an empty hash we only need one object.
  EMPTY_OPTIONS = {}
  EMPTY_LIST = []

  REGISTERED_OBJECTS = {
    "Mailbox" => Mail::Mailbox
  }


  def self.connect(url:, bearer_token:, adapter: nil, stubs: nil)
    Core::Client.new(url:, bearer_token:, adapter:, stubs:) 
  end
end
