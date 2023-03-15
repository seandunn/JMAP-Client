# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Mail::Mailbox do
  include_context "with a valid Client and Session:"

  context "When getting all Mailboxes in a Account:" do
    let(:mailboxes_json) { JSON.parse File.read("spec/fixtures/mail/mailboxes.json") }
    let(:expected_request_json) do
      expected_request_json = <<-END_JSON
      {
        "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
        "methodCalls": [
          [ "Mailbox/get", { "accountId": "DUMMY-ACCOUNT-ID", "ids": null }, 0 ]
        ]
      }
      END_JSON
    end

    it "Makes a correctly formed request to the server." do
      
    end

    it "Returns an Array of Mailbox objects." # do
      # stubs.post("/jmap/api") do
      # [ 200, { 'Content-Type': 'application/javascript' }, mailboxes_json ]
      # end
      #
      # mailboxes = client.mailboxes
      #
      # expect(mailboxes.first).to eq(dummy_inbox)
    # end
  end
end
