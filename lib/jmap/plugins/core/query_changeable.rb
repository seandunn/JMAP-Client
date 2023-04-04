# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module QueryChangeable
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          include Core::Invocable

          # The Foo/queryChanges method allows a client to efficiently update the
          # state of a cached query to match the new state on the server.
          def query_changes(request, &block)
            invoke(:query_changes, request, &block)
          end
        end

        class QueryChanges
          # accountId: Id The id of the account to use.
          attr_reader :account_id

          # filter: FilterOperator|FilterCondition|null The filter argument that
          # was used with Foo/query.
          attr_accessor :filter


          # sort: Comparator[]|null The sort argument that was used with Foo/query.
          attr_reader :sort

          # sinceQueryState: String The current state of the query in the client. This is the string that was returned as the queryState argument in the Foo/query response with the same sort/filter. The server will return the changes made to the query since this state.
          attr_accessor :since_query_state

          # maxChanges: UnsignedInt|null The maximum number of changes to return in the response. See error descriptions below for more details.
          attr_accessor :max_changes

          # upToId: Id|null The last (highest-index) id the client currently has cached from the query results. When there are a large number of results, in a common case, the client may have only downloaded and cached a small subset from the beginning of the results. If the sort and filter are both only on immutable properties, this allows the server to omit changes after this point in the results, which can significantly increase efficiency. If they are not immutable, this argument is ignored.
          attr_accessor :up_to_id

          # calculateTotal: Boolean (default: false) Does the client wish to know the total number of results now in the query? This may be slow and expensive for servers to calculate, particularly with complex filters, so clients should take care to only request the total when needed.
          attr_accessor :calculate_total

          def initialize(account_id)
            @account_id = account_id
            @sort = []
            @calculate_total = false
          end

          def add_sort(opts)
            @sort << opts
          end

          def as_json
            {
              "accountId" => account_id,
              "calculateTotal" => calculate_total,
              "filter" => filter,
              "maxChanges" => max_changes,
              "sinceQueryState" => since_query_state,
              "sort" => sort,
              "upToId" => up_to_id
            }
          end
        end
      end
    end
  end
end
