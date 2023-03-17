# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup

require "jmap/client"
require "jmap/session"

module JMAP
  # For methods params that default to an empty hash we only need one object.
  EMPTY_OPTIONS = {}
  EMPTY_LIST = []

  REGISTERED_OBJECTS = {}
  PLUGINS = {}

  def self.register_plugin(capability, mod)
    mod_name = truncate_capability(capability)
    PLUGINS[mod_name] = mod
    REGISTERED_OBJECTS.merge! mod::REGISTERED_OBJECTS
  end

  # returns [Symbol]
  def self.truncate_capability(capability)
    capability.split(":").last.downcase.to_sym
  end

  # Loads Plugin based on JMAP capability name or from its module.
  def self.plugin(mod)
    if mod.is_a?(String)
      mod_name = truncate_capability(mod)
      require "jmap/plugins/#{mod_name}"

      mod = PLUGINS.fetch(mod_name)
    end

    if defined?(mod::ClientMethods)
      self::Client.include(mod::ClientMethods)
    end

    mod.after_load if mod.respond_to?(:after_load) 
  end

  def self.plugins(capabilities)
    capabilities.each { |capability| plugin(capability) }
  end

  def self.connect(url:, bearer_token:, adapter: nil, stubs: nil)
    client = Client.new(url:, bearer_token:, adapter:, stubs:) 
    plugins(client.session.capabilities.keys)
    client
  end
end
