# frozen_string_literal: true

module JMAP
  module Core
    # Method calls and responses are represented by Invocation.
    class Invocation
      # The class converts to a tupple represented as a JSON array containing
      # three elements:

      # A String name of the method to call or of the response.
      attr_reader :name

      # Hash containing named arguments for that method or response.
      attr_reader :arguments

      # An arbitrary string from the client to be echoed back with the
      # responses emitted by that method call (a method may return 1 or more
      # responses, as it may make implicit calls to other methods; all
      # responses initiated by this method call get the same method call id
      # in the response).
      attr_accessor :method_call_id

      def initialize(name:, arguments:)
        @name = name
        @arguments = arguments
        @method_call_id = method_call_id
      end

      def as_json(options=EMPTY_OPTIONS)
        [name, arguments, method_call_id]
      end

      def to_json(*options)
        as_json(*options).to_json(*options)
      end

    end
  end
end
