# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail

      # An EmailSubmission object represents the submission of an
      # Email for delivery to one or more recipients.
      class EmailSubmission
        include JMAP::Plugins::Core::Gettable
        include JMAP::Plugins::Core::Changeable
        include JMAP::Plugins::Core::Queryable
        include JMAP::Plugins::Core::QueryChangeable
        include JMAP::Plugins::Core::Settable


        # id: Id (immutable; server-set) The id of the
        # EmailSubmission.
        attr_reader :id

        # identityId: Id (immutable) The id of the Identity to
        # associate with this submission.
        attr_reader :identity_id

        # emailId: Id (immutable) The id of the Email to send. The
        # Email being sent does not have to be a draft, for
        # example, when “redirecting” an existing Email to
        # a different address.
        attr_reader :email_id

        # threadId: Id (immutable; server-set) The Thread id of
        # the Email to send. This is set by the server to the
        # threadId property of the Email referenced by the
        # emailId.
        attr_reader :thread_id

        # envelope: Envelope|null (immutable) Information for use
        # when sending via SMTP.
        attr_reader :envelope

        # sendAt: UTCDate (immutable; server-set) The date the submission was/will be
        # released for delivery.
        #
        # If the client successfully used FUTURERELEASE [@!RFC4865] with the
        # submission, this MUST be the time when the server will release the
        # message; otherwise, it MUST be the time the EmailSubmission was
        # created.
        attr_reader :send_at

        # undoStatus: String This represents whether the submission may be
        # canceled. This is server set on create and MUST be one of the
        # following values:
        #
        # pending: It may be possible to cancel this submission.
        #
        # final: The message has been relayed to at least one recipient in
        # a manner that cannot be recalled. It is no longer possible to cancel
        # this submission.
        #
        # canceled: The submission was canceled and will not be delivered to any recipient.
        attr_reader :undo_status

        # deliveryStatus: String[DeliveryStatus]|null (server-set) This
        # represents the delivery status for each of the submission’s
        # recipients, if known. This property MAY not be supported by all
        # servers, in which case it will remain null. Servers that support it
        # SHOULD update the EmailSubmission object each time the status of any
        # of the recipients changes, even if some recipients are still being
        # retried.
        attr_reader :delivery_status
        end

      end
    end
  end

