# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      # An Email object is a representation of a message [@!RFC5322], which
      # allows clients to avoid the complexities of MIME parsing, transfer
      # encoding, and character encoding.
      class Email < OpenStruct
        include JMAP::Plugins::Core::Queryable
        include JMAP::Plugins::Core::Getable

        THREAD_ID = "threadId"
        MAILBOX_IDS = "mailboxIds"
        KEYWORDS = "keywords"
        HAS_ATTACHMENT = "hasAttachment"
        FROM = "from"
        SUBJECT = "subject"
        RECEIVED_AT = "receivedAt"
        SIZE = "size"
        PREVIEW =  "preview"
      end
    end
  end
end


