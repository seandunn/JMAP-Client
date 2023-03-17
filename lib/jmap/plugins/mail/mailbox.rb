# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      # A Mailbox represents a named set of Emails. This is the primary mechanism
      # for organising Emails within an account. It is analogous to a folder or
      # a label in other systems. A Mailbox may perform a certain role in the
      # system; see below for more details.
      #
      # For compatibility with IMAP, an Email MUST belong to one or more
      # Mailboxes. The Email id does not change if the Email changes Mailboxes.
      class Mailbox
        # Get is the correct method name to fetch all mailboxes according to JMAP
        # spec.  Aliased to .all and .find as that's probably more familiar to
        # ruby users.
        #
        # TODO: Move this to a general Resource class
        def self.get(client, ids=EMPTY_LIST)
          name = "#{self.name.split("::").last}/get"
          arguments = { accountId: client.account_id, ids: nil}
          JMAP::Plugins::Core::Invocation.new(name:, arguments:)
        end

        def initialize(json_hash)
          @json_hash = json_hash
        end

        # Id (immutable; server-set) The id of the Mailbox.
        def id 
          @json_hash["id"]
        end

        # String User-visible name for the Mailbox, e.g., “Inbox”. This MUST be
        # a Net-Unicode string [@!RFC5198] of at least 1 character in length,
        # subject to the maximum size given in the capability object. There MUST
        # NOT be two sibling Mailboxes with both the same parent and the same
        # name. Servers MAY reject names that violate server policy (e.g., names
        # containing a slash (/) or control characters).
        def name 
          @json_hash["name"]
        end

        # :parentId Id|null (default: null) The Mailbox id for the parent of this Mailbox, or
        # null if this Mailbox is at the top level. Mailboxes form acyclic graphs
        # (forests) directed by the child-to-parent relationship. There MUST NOT
        # be a loop.
        def parent_id 
          @json_hash["parentId"]
        end

        # # role: String|null (default: null) Identifies Mailboxes that have
        # # a particular common purpose (e.g., the “inbox”), regardless of the name
        # # property (which may be localised).
        # #
        # # This value is shared with IMAP (exposed in IMAP via the SPECIAL-USE
        # # extension [@!RFC6154]). However, unlike in IMAP, a Mailbox MUST only
        # # have a single role, and there MUST NOT be two Mailboxes in the same
        # # account with the same role. Servers providing IMAP access to the same
        # # data are encouraged to enforce these extra restrictions in IMAP as
        # # well. Otherwise, modifying the IMAP attributes to ensure compliance
        # # when exposing the data over JMAP is implementation dependent.
        # #
        # # The value MUST be one of the Mailbox attribute names listed in the IANA
        # # IMAP Mailbox Name Attributes registry, as established in [@!RFC8457],
        # # converted to lowercase. New roles may be established here in the
        # # future.
        # attr_reader :role
        #
        # # sortOrder: UnsignedInt (default: 0) Defines the sort order of Mailboxes when
        # # presented in the client’s UI, so it is consistent between devices. The
        # # number MUST be an integer in the range 0 <= sortOrder < 2^31.
        # #
        # # A Mailbox with a lower order should be displayed before a Mailbox with
        # # a higher order (that has the same parent) in any Mailbox listing in the
        # # client’s UI. Mailboxes with equal order SHOULD be sorted in
        # # alphabetical order by name. The sorting should take into account
        # # locale-specific character order convention.
        # attr_reader :sortOrder
        #
        #
        # # totalEmails: UnsignedInt (server-set) The number of Emails in this Mailbox.
        # attr_reader :totalEmails
        #
        # # unreadEmails: UnsignedInt (server-set) The number of Emails in this
        # # Mailbox that have neither the $seen keyword nor the $draft keyword.
        # attr_reader :unreadEmails
        #
        # # totalThreads: UnsignedInt (server-set) The number of Threads where at least
        # # one Email in the Thread is in this Mailbox.
        # attr_reader :totalThreads
        #
        # # unreadThreads: UnsignedInt (server-set) An indication of the number of
        # # “unread” Threads in the Mailbox.
        # attr_reader :unreadThreads
        #
        # # myRights: MailboxRights (server-set) The set of rights (Access Control
        # # Lists (ACLs)) the user has in relation to this Mailbox. These are
        # # backwards compatible with IMAP ACLs, as defined in [@!RFC4314].
        # attr_reader :myRights
        #
        # # isSubscribed: Boolean Has the user indicated they wish to see this
        # # Mailbox in their client? This SHOULD default to false for Mailboxes in
        # # shared accounts the user has access to and true for any new Mailboxes
        # # created by the user themself.
        # attr_reader :isSubscribed

      end
    end
  end
end
