# frozen_string_literal: true

require "faraday"

module JMAP
  module Plugins
    module Core
      CAPABILITY = "urn:ietf:params:jmap:core"

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

        def api_url
          session.api_url
        end

        # Current assumption is that Core userId will be the same as for the
        # other capabilities.  This is almost certainly wrong. :(
        # TODO: In which case this should be based on which operation you're doing.
        def account_id
          session.primary_accounts[JMAP::Plugins::Core::CAPABILITY]
        end

        # @returns [JMAP::Plugins::Core::Session]
        def session
          return @session if defined?(@session)
          response = connection.get url
          @session = Session.new(response.body)
        end

        def capabilities
          session.capabilities.keys
        end

        # @returns [Array<JMAP::Plugins::Mail::Mailbox>]
        def mailboxes
          request = Request.new(capabilities)
          request << JMAP::Plugins::Mail::Mailbox.get(self)
          res = connection.post(api_url) do |req|
            req.body = request.to_json
          end

          raise BadResponseError if res.body == ""

          response = JMAP::Plugins::Core::Response.new(res.body)
          response.method_responses.flatten
        end

        private
        attr_reader :connection

        class Error < StandardError; end
        class BadResponseError < StandardError; end
      end
    end
  end
end
