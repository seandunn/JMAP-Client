# frozen_string_literal: true

module JMAP
  module Core
    # Holds a list of method calls (Invocations) to be made against a JMAP
    # server in a single network call.
    class Request
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

      def initialize(capabilities)
        @using = capabilities
        @invocations = []
      end

      # Set the method_call_id base on position in invocations at time of
      # insertion.  This is an arbitrary value which could be replaced with
      # a UUID later.
      def <<(invocation)
        invocation.method_call_id = invocations.size
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
