# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      # Holds a list of method calls (Invocations) to be made against a JMAP
      # server in a single network call.
      class Request
        # This is needs to be passed to invocations withing the request.
        attr_reader :account_id

        # The set of capabilities the client wishes to use. The client MAY
        # include capability identifiers even if the method calls it makes do
        # not utilise those capabilities.
        attr_reader :using

        # An array of method calls to process on the server. The method calls
        # MUST be processed sequentially, in order.
        attr_reader :invocations

        # (optional) A map of a (client-specified) creation id to the id the
        # server assigned when a record was successfully created.
        attr_reader :created_ids

        def initialize(account_id, capabilities)
          @account_id = account_id
          @using = capabilities
          @invocations = []
        end

        # Set the method_call_id base on position in invocations at time of
        # insertion.  This is an arbitrary value which could be replaced with
        # a UUID later.
        def <<(invocation)
          invocation.method_call_id = invocations.size.to_s
          invocations << invocation
        end

        def as_json(options=EMPTY_OPTIONS)
          {
            "using" => using,
            "methodCalls" => invocations
          }
        end

        def to_json(*options)
          as_json(*options).to_json(*options)
        end

      end
    end
  end
end
