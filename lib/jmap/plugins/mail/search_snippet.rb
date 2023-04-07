# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      # When doing a search on a String property, the client may wish to show
      # the relevant section of the body that matches the search as a preview
      # and to highlight any matching terms in both this and the subject of the
      # Email. Search snippets represent this data.
      class SearchSnippet
        extend Core::Invocable

        # emailId: Id The Email id the snippet applies to.
        attr_accessor :email_id

        # subject: String|null If text from the filter matches the subject,
        # this is the subject of the Email with the following transformations:
        #
        # Any instance of the following three characters MUST be replaced by an
        # appropriate HTML entity: & (ampersand), < (less-than sign), and
        # > (greater-than sign) HTML. Other characters MAY also be replaced
        # with an HTML entity form.
        #
        # The matching words/phrases from the filter are wrapped in HTML
        # <mark></mark> tags.
        #
        # If the subject does not match text from the filter, this property is
        # null.
        attr_accessor :subject

        # preview: String|null If text from the filter matches the plaintext or
        # HTML body, this is the relevant section of the body (converted to
        # plaintext if originally HTML), with the same transformations as the
        # subject property. It MUST NOT be bigger than 255 octets in size. If
        # the body does not contain a match for the text from the filter, this
        # property is null.
        attr_accessor :preview

        def self.get(request, &block)
          self.invoke(:get, request, &block)
        end

        class Get
          attr_accessor :account_id

          # filter: FilterOperator|FilterCondition|null The same filter as
          # passed to Email/query
          attr_accessor :filter

          # emailIds: Id[] The ids of the Emails to fetch snippets for.
          attr_accessor :email_ids

          def initialize(account_id)
            @account_id = account_id
          end

          def as_json
            {
              accountId: account_id,
              filter: filter,
              emailIds: email_ids
            }
          end
        end
      end
    end
  end
end

