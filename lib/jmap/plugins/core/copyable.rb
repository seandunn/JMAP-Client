# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Copyable
        def self.included(base) 
          base.extend(ClassMethods)
        end

        module ClassMethods
          include Core::Invocable

          def copy(request, &block)
            invoke(:copy, request, &block)
          end
        end

        class CopyArguments
          # accountId: Id The id of the account to copy records to. This MUST
          # be different to the fromAccountId.
          #
          # Defaulted to the Request's account_id unless one is set by the
          # user.
          attr_accessor :account_id

          # fromAccountId: Id The id of the account to copy records from.
          attr_accessor :from_account_id

          # ifFromInState: String|null This is a state string as returned by
          # the Foo/get method. If supplied, the string must match the current
          # state of the account referenced by the fromAccountId when reading
          # the data to be copied; otherwise, the method will be aborted and
          # a stateMismatch error returned. If null, the data will be read from
          # the current state.
          attr_accessor :if_from_in_state

          # ifInState: String|null This is a state string as returned by the
          # Foo/get method. If supplied, the string must match the current
          # state of the account referenced by the accountId; otherwise, the
          # method will be aborted and a stateMismatch error returned. If null,
          # any changes will be applied to the current state.
          attr_accessor :if_in_state

          # create: Id[Foo] A map of the creation id to a Foo object. The Foo
          # object MUST contain an id property, which is the id (in the
          # fromAccount) of the record to be copied. When creating the copy,
          # any other properties included are used instead of the current value
          # for that property on the original.
          attr_accessor :create

          # onSuccessDestroyOriginal: Boolean (default: false) If true, an
          # attempt will be made to destroy the original records that were
          # successfully copied: after emitting the Foo/copy response, but
          # before processing the next method, the server MUST make a single
          # call to Foo/set to destroy the original of each successfully copied
          # record; the output of this is added to the responses as normal, to
          # be returned to the client.
          attr_accessor :on_success_destroy_original

          # destroyFromIfInState: String|null This argument is passed on as the
          # ifInState argument to the implicit Foo/set call, if made at the end
          # of this request to destroy the originals that were successfully
          # copied.
          attr_accessor :destroy_from_if_in_state

          def initialize(account_id)
            @account_id = account_id
            @on_success_destroy_original = false
          end

          def as_json
            build = {
              accountId: account_id,
              fromAccountId: from_account_id,
              create: create,
              onSuccessDestroyOriginal: on_success_destroy_original
            }

            build[:ifFromInState] = if_from_in_state if if_from_in_state
            build[:if_in_state] = if_in_state if if_in_state

            build[:destroyFromIfInState] = destroy_from_if_in_state if destroy_from_if_in_state

            build
          end
        end
      end
    end
  end
end
