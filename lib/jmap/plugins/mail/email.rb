# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      # An Email object is a representation of a message [@!RFC5322], which
      # allows clients to avoid the complexities of MIME parsing, transfer
      # encoding, and character encoding.
      class Email < OpenStruct
        include JMAP::Plugins::Core::Gettable
        include JMAP::Plugins::Core::Changeable
        include JMAP::Plugins::Core::Queryable
        include JMAP::Plugins::Core::QueryChangeable
        include JMAP::Plugins::Core::Settable
        include JMAP::Plugins::Core::Copyable

        ATTACHMENTS = "attachments"
        BCC = "bcc"
        BLOB_ID = "blobIc"
        BODY_VALUES = "bodyValues"
        CC = "cc"
        FROM = "from"
        HAS_ATTACHMENT = "hasAttachment"
        HTML_BODY = "htmlBody"
        ID = "id"
        IN_REPLY_TO = "inReplyTo"
        KEYWORDS = "keywords"
        MAILBOX_IDS = "mailboxIds"
        MESSAGE_ID ="messageId"
        PREVIEW =  "preview"
        RECEIVED_AT = "receivedAt"
        REFERENCES = "references"
        REPLY_TO = "replyTo"
        SENDER = "sender"
        SENT_AT = "sentAt"
        SIZE = "size"
        SUBJECT = "subject"
        TEXT_BODY = "textBody"
        THREAD_ID = "threadId"
        TO = "to"

        DEFAULT_PROPERTIES = [
          ID, BLOB_ID, THREAD_ID, MAILBOX_IDS, KEYWORDS, SIZE, RECEIVED_AT,
          MESSAGE_ID, IN_REPLY_TO, REFERENCES, SENDER, FROM, TO, CC, BCC,
          REPLY_TO, SUBJECT, SENT_AT, HAS_ATTACHMENT, PREVIEW, BODY_VALUES,
          TEXT_BODY, HTML_BODY, ATTACHMENTS 
        ]
      end
    end
  end
end


