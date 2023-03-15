# frozen_string_literal: true

module JMAP
  module Core
    # Represents a response from the JMAP server.
    class Response
      # Invocation[] An array of responses, in the same format as the methodCalls on the
      # Request object. The output of the methods MUST be added to the
      # methodResponses array in the same order that the methods are processed.
      attr_reader :method_responses

      # Id[Id] (optional; only returned if given in the request) A map of
      # a (client-specified) creation id to the id the server assigned when
      # a record was successfully created. This MUST include all creation ids
      # passed in the original createdIds parameter of the Request object, as
      # well as any additional ones added for newly created records.
      attr_reader :created_ids


      # String The current value of the “state” string on the Session object,
      # as described in Section 2. Clients may use this to detect if this
      # object has changed and needs to be refetched.
      attr_reader :session_state

      def initialize(body_json)
        @method_responses = Invocation.from_response(body_json["methodResponses"])
        @created_ids = body_json["createdIds"]
        @session_state = body_json["sessionState"]
      end
    end
  end
end
