# frozen_string_literal: true

require "jmap/plugins/mail/client_methods"
require "jmap/plugins/mail/mailbox"
require "jmap/plugins/mail/email"
require "jmap/plugins/mail/thread"

module JMAP
  module Plugins
    module Mail
      CAPABILITY = "urn:ietf:params:jmap:mail"

      REGISTERED_OBJECTS = {
        "Mailbox" => Mailbox,
        "Email" => Email,
        "Thread" => Thread
      }

      JMAP.register_plugin(CAPABILITY, self)

      def self.before_load
        JMAP.plugin("core")
      end
    end
  end
end

