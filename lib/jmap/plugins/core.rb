# frozen_string_literal: true

require "jmap/plugins/core/invocable"
require "jmap/plugins/core/back_reference"
require "jmap/plugins/core/changeable"
require "jmap/plugins/core/copyable"
require "jmap/plugins/core/settable"
require "jmap/plugins/core/query_changeable"
require "jmap/plugins/core/client_methods"
require "jmap/plugins/core/comparator"
require "jmap/plugins/core/filter_operator"
require "jmap/plugins/core/gettable"
require "jmap/plugins/core/invocation"
require "jmap/plugins/core/queryable"
require "jmap/plugins/core/request"
require "jmap/plugins/core/response"

module JMAP
  module Plugins
    module Core
      extend Invocable

      CAPABILITY = "urn:ietf:params:jmap:core"

      # Unlike other Plugins we don't map any JMAP objects to Plugin classes.
      REGISTERED_OBJECTS = EMPTY_OPTIONS

      JMAP.register_plugin(CAPABILITY, self)

      def self.echo(request, &block)
        self.invoke(:echo, request, &block)
      end

      class EchoArguments
        attr_accessor :message

        def initialize(_); end

        def as_json
          { message: message }
        end
      end

    end
  end
end

