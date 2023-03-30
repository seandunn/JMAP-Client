# frozen_string_literal: true

module JMAP
  module Plugins
    module  Core
      module ClientMethods
        def api_url
          session.api_url
        end

        # Current assumption is that Core userId will be the same as for the
        # other capabilities.  This is almost certainly wrong. :(
        # TODO: In which case this should be based on which operation you're doing.
        def account_id
          session.primary_accounts[JMAP::Plugins::Core::CAPABILITY]
        end

        def capabilities
          session.capabilities.keys
        end

        def request
          request = Request.new(account_id, capabilities)
          yield request

          res = connection.post(api_url) do |req|
            req.body = request.to_json
          end

          raise BadResponseError if res.body == ""

          JMAP::Plugins::Core::Response.new(res.body)
        end

      end
    end
  end 
end
