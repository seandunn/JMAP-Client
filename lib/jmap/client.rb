# frozen_string_literal: true

require "faraday"

module JMAP
  class Client
    attr_reader :url # The URL for the JMAP Session resource.

    def initialize(url:, bearer_token:, adapter: Faraday.default_adapter, stubs: nil)
      @url = url

      @connection = Faraday.new(url:) do |builder|
        builder.request :authorization, "Bearer", bearer_token
        builder.request :json

        builder.response :json

        builder.adapter adapter, stubs
      end
    end

    # @returns [JMAP::Session]
    def session
      return @session if defined?(@session)
      response = connection.get url
      @session = JMAP::Session.new(response.body)
    end

    private
    attr_reader :connection

    class Error < StandardError; end
    class BadResponseError < StandardError; end
  end
end
