# frozen_string_literal: true

module JMAP
  module Plugins
    module Core

      # When the state of the set of Foo records in an account changes on the
      # server (whether due to creation, updates, or deletion), the state
      # property of the Foo/get response will change. The Foo/changes method
      # allows a client to efficiently update the state of its Foo cache to
      # match the new state on the server. 
      module Changeable
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          include Core::Invocable

          def changes(request, &block)
            invoke(:changes, request, &block)
          end
        end

        class ChangesArguments
          # accountId: Id The id of the account to use.
          attr_reader :account_id

          # sinceState: String The current state of the client. This is the
          # string that was returned as the state argument in the Foo/get
          # response. The server will return the changes that have occurred
          # since this state.
          attr_accessor :since_state

          # maxChanges: UnsignedInt|null The maximum number of ids to return in
          # the response. The server MAY choose to return fewer than this value
          # but MUST NOT return more. If not given by the client, the server
          # may choose how many to return. If supplied by the client, the value
          # MUST be a positive integer greater than 0. If a value outside of
          # this range is given, the server MUST reject the call with an
          # invalidArguments error.
          attr_accessor :max_changes

          def initialize(account_id)
            @account_id = account_id
          end

          def as_json
            build = { accountId: account_id }
            build[:sinceState] = since_state if since_state
            build[:maxChanges] = max_changes if max_changes
            build
          end
        end
      end
    end
  end
end

