# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      module ClientMethods
        # @returns [Array<JMAP::Plugins::Mail::Mailbox>]
        def mailboxes
          request = JMAP::Plugins::Core::Request.new(capabilities)
          request << JMAP::Plugins::Mail::Mailbox.get(self)
          res = connection.post(api_url) do |req|
            req.body = request.to_json
          end

          raise BadResponseError if res.body == ""

          response = JMAP::Plugins::Core::Response.new(res.body)
          response.method_responses.flatten
        end

      end
    end
  end
end
