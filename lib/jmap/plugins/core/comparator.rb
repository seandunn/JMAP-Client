# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      class Comparator
        # property: String The name of the property on the Foo objects to compare.
        attr_reader :property

        # isAscending: Boolean (optional; default: true) If true, sort in ascending order. If false, reverse the comparator’s results to sort in descending order.
        attr_reader :is_ascending

        # collation: String (optional; default is server dependent) The
        # identifier, as registered in the collation registry defined in
        # [@!RFC4790], for the algorithm to use when comparing the order of
        # strings.
        attr_reader :collation
        
        def initialize(property:, is_ascending: true, collation: nil)
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
