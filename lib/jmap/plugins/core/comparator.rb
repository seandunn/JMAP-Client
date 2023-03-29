# # frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      class Comparator
        attr_reader :property
        attr_reader :is_ascending
        attr_reader :collation
        
        def initialize(property:, is_ascending:, collation: nil)
          @property = property
          @is_ascending = is_ascending
          @collation = collation
        end

        def as_json(options=EMPTY_OPTIONS)
          json = {
            "property" => property,
            "isAscending" => is_ascending
          }

          json["collation"] = collation if collation
          json
        end

        def to_json(*options)
          as_json(*options).to_json(*options)
        end

      end
    end
  end
end
