# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Queryable
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          include Invocable

          def query(request, &block)
            invoke(:query, request, &block)
          end
        end


        # Hold the parameters for a /query invocation.
        class Query
          attr_accessor :account_id
          attr_accessor :calculate_total
          attr_accessor :collapse_threads
          attr_accessor :filter
          attr_accessor :limit
          attr_accessor :position
          attr_reader :sort

          def initialize(account_id)
            @account_id = account_id
            @sort = []
            @collapse_threads = false
            @position = 0
            @limit = 30
            @calculate_total = false
          end

          def add_sort(opts)
            @sort << opts
          end

          def as_json
            {
              "accountId" => account_id,
              "calculateTotal" => calculate_total,
              "collapseThreads" => collapse_threads,
              "filter" => filter,
              "limit" => limit,
              "position" => position,
              "sort" => sort
            }
          end
        end
      end
    end
  end
end

