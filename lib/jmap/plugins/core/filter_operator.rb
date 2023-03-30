# frozen_string_literal: true

module JMAP
  module Plugins
    module Core

      # Determines the set of Foos returned in the results. 
      class FilterOperator
        class InvalidOperatorError < StandardError; end

        OPERATORS = Set[:AND, :OR, :NOT]

        # operator: String This MUST be one of the following strings: “AND”
        # / “OR” / “NOT”:
        # AND: All of the conditions must match for the filter to match.
        # OR: At least one of the conditions must match for the filter to match.
        # NOT: None of the conditions must match for the filter to match.
        attr_reader :operator

        # conditions: (FilterOperator|FilterCondition)[] The conditions to
        # evaluate against each record.
        #
        # A FilterCondition is an object whose allowed properties and semantics
        # depend on the data type and is defined in the /query method
        # specification for that type. It MUST NOT have an operator property.
        attr_reader :conditions

        def initialize(operator:, conditions:)
          raise InvalidOperatorError, "Bad logic operator: #{operator}.  It must be in the set of #{OPERATORS}." unless OPERATORS.include?(operator)

          @operator = operator
          @conditions = conditions
        end
      end

    end
  end
end
