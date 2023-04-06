# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      # Modifying the state of Foo objects on the server is done via the
      # Foo/set method. This encompasses creating, updating, and destroying Foo
      # records. This allows the server to sort out ordering and dependencies
      # that may exist if doing multiple operations at once (for example, to
      # ensure there is always a minimum number of a certain record type).
      module Settable
        def self.included(base) 
          base.extend(ClassMethods)
        end

        module ClassMethods
          include Core::Invocable

          def set(request, &block)
            invoke(:set, request, &block)
          end
        end

        class Set
          # accountId: Id The id of the account to use.
          attr_accessor :account_id


          # ifInState: String|null This is a state string as returned by the
          # Foo/get method (representing the state of all objects of this type
          # in the account). If supplied, the string must match the current
          # state; otherwise, the method will be aborted and a stateMismatch
          # error returned. If null, any changes will be applied to the current
          # state.
          attr_accessor :if_in_state

          # create: Id[Foo]|null A map of a creation id (a temporary id set by
          # the client) to Foo objects, or null if no objects are to be
          # created.
          #
          # The Foo object type definition may define default values for
          # properties. Any such property may be omitted by the client.
          #
          # The client MUST omit any properties that may only be set by the
          # server (for example, the id property on most object types).
          attr_accessor :create

          # update: Id[PatchObject]|null A map of an id to a Patch object to
          # apply to the current Foo object with that id, or null if no objects
          # are to be updated.
          attr_accessor :update

          # destroy: Id[]|null A list of ids for Foo objects to permanently
          # delete, or null if no objects are to be destroyed.
          attr_accessor :destroy

          def initialize(account_id)
            @account_id = account_id
            @on_success_destroy_original = false
          end

          def as_json
            build = { accountId: account_id }

            build[:create] = create if create
            build[:ifInState] = if_in_state if if_in_state
            build[:update] = update if update
            build[:destroy] = destroy if destroy

            build
          end
        end
      end
    end
  end
end
