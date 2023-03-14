# frozen_string_literal: true

require "zeitwerk"
require "jmap/core/client"
require "jmap/core/session"
require "jmap/mail/mailbox"

Zeitwerk::Loader.for_gem.setup

module JMAP
  def self.connect(url:, bearer_token:, adapter: nil, stubs: nil)
    Core::Client.new(url:, bearer_token:, adapter:, stubs:) 
  end
end
