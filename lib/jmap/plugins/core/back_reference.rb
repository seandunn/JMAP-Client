# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      class BackReference
        attr_reader :result_of
        attr_reader :name
        attr_reader :path

        def initialize(result_of:, name:, path:)
          @result_of = result_of
          @name = name
          @path = path
        end

        def as_json(options=EMPTY_OPTIONS)
          {
            resultOf: result_of.to_s,
            name:,
            path:
          }
        end

        def to_json(*options)
          as_json(*options).to_json(*options)
        end

      end
    end
  end
end

