# frozen_string_literal: true

require "jmap/plugins/core/client_methods"
require "jmap/plugins/core/invocation"
require "jmap/plugins/core/request"
require "jmap/plugins/core/response"

module JMAP
  module Plugins
    module Core
      CAPABILITY = "urn:ietf:params:jmap:core"

      # Unlike other Plugins we don't map any JMAP objects to Plugin classes.
      REGISTERED_OBJECTS = EMPTY_OPTIONS

      JMAP.register_plugin(CAPABILITY, self)

    end
  end
end

