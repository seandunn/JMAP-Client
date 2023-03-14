# frozen_string_literal: true

require "faraday"

module JMAP
  module Core
    # A Session object holds details about the data and capabilities a server
    # can provide to the client given based on the credentials provided.
    class Client
      attr_reader :url # The URL for the JMAP Session resource.

      def initialize(url:, bearer_token:, adapter: Faraday.default_adapter, stubs: nil)
        @url = url

        @connection = Faraday.new url: do |builder|
          builder.request :authorization, "Bearer", bearer_token
          builder.request :json

          builder.response :json

          builder.adapter adapter, stubs
        end
      end

      # @returns [JMAP::Core::Session]
      def session
        return @session if defined?(@session)
        response = @connection.get url
        @session = Session.new(response.body)
      end

    end
  end
end
