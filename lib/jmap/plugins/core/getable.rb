# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Getable
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          # Refactor
          def get(request)
            get = Get.new(request.account_id)
            yield get

            invocation = Invocation.new(
              name: "#{class_name}/get",
              arguments: get.as_json
            )

            request << invocation

            # Return the invocation so that it can be used for back references
            # in the response.
            invocation
          end

          # Refactor
          def class_name = self.name.split("::").last
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
            build[:properties] = properties if properties
            build
          end

          private
          def build_ids(build)
            return unless ids

            if ids.is_a?(BackReference)
              build["#ids"] = ids
            else
              build["ids"] = ids
            end
          end
        end
      end
    end
  end
end
