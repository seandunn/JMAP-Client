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
      end

    end
  end
end

