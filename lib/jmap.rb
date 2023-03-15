# frozen_string_literal: true

require "zeitwerk"

require "jmap/plugins/core"
require "jmap/plugins/mail"

Zeitwerk::Loader.for_gem.setup

module JMAP
  # For methods params that default to an empty hash we only need one object.
  EMPTY_OPTIONS = {}
  EMPTY_LIST = []

  REGISTERED_OBJECTS = {
    "Mailbox" => Plugins::Mail::Mailbox
  }

  PLUGINS = {}

  def self.plugin(mod)
    if defined?(mod::ClientMethods)
  end

  def self.connect(url:, bearer_token:, adapter: nil, stubs: nil)
    Plugins::Core::Client.new(url:, bearer_token:, adapter:, stubs:) 
  end
end
