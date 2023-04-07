# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail

      # A vacation response sends an automatic reply when
      # a message is delivered to the mail store, informing the
      # original sender that their message may not be read for
      # some time.
      class VacationResponse
        include JMAP::Plugins::Core::Gettable
        include JMAP::Plugins::Core::Settable


        # id: Id (immutable; server-set) The id of the object. There is only ever
        # one VacationResponse object, and its id is "singleton".
        attr_reader :id

        # isEnabled: Boolean Should a vacation response be sent if a message
        # arrives between the fromDate and toDate?
        attr_accessor :is_enabled

        # fromDate: UTCDate|null If isEnabled is true, messages that arrive on or
        # after this date-time (but before the toDate if defined) should receive
        # the user’s vacation response. If null, the vacation response is effective
        # immediately.
        attr_accessor :from_date

        # toDate: UTCDate|null If isEnabled is true, messages that arrive before
        # this date-time (but on or after the fromDate if defined) should receive
        # the user’s vacation response. If null, the vacation response is
        # effective indefinitely.
        attr_accessor :to_date

        # subject: String|null The subject that will be used by the message sent in
        # response to messages when the vacation response is enabled. If null, an
        # appropriate subject SHOULD be set by the server.
        attr_accessor :subject

        # textBody: String|null The plaintext body to send in response
        # to messages when the vacation response is enabled. If this is
        # null, the server SHOULD generate a plaintext body part from
        # the htmlBody when sending vacation responses but MAY choose
        # to send the response as HTML only. If both textBody and
        # htmlBody are null, an appropriate default body SHOULD be
        # generated for responses by the server.
        attr_accessor :text_body

        # htmlBody: String|null The HTML body to send in response to
        # messages when the vacation response is enabled. If this is
        # null, the server MAY choose to generate an HTML body part
        # from the textBody when sending vacation responses or MAY
        # choose to send the response as plaintext only.
        attr_accessor :html_body
        end

      end
  end
end

