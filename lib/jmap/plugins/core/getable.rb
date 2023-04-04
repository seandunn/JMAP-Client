# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Getable
        def self.included(base) 
          base.extend(ClassMethods)
        end

        module ClassMethods
          include Core::Invocable

          def get(request, &block)
            invoke(:get, request, &block)
          end
        end

        class Get
          attr_reader :account_id
          attr_accessor :ids
          attr_accessor :properties

          def initialize(account_id)
            @account_id = account_id
          end

          def as_json
            build = { accountId: account_id }
            build_ids(build)
            build_properties(build)
            build
          end

          private
          # TODO: refactor these two build methods
          def build_ids(build)
            return unless ids

            if ids.is_a?(BackReference)
              build["#ids"] = ids
            else
              build["ids"] = ids
            end
          end

          def build_properties(build)
            return unless properties

            if properties.is_a?(BackReference)
              build["#properties"] = properties
            else
              build["properties"] = properties
            end
          end
        end
      end
    end
  end
end
