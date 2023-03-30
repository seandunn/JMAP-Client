# frozen_string_literal: true

require "spec_helper"

JMAP.plugin("mail")

RSpec.describe JMAP::Plugins::Mail::Mailbox do
  include_context "with a valid Client and Session:"

  context "When getting all Mailboxes in a Account:" do
    let(:mailboxes_json) { JSON.parse File.read("spec/fixtures/mail/mailboxes.json") }
    let(:expected_request_json) do
      {
        "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
        "methodCalls": [
          [ "Mailbox/get", { "accountId": "DUMMY-ACCOUNT-ID" }, "0" ]
        ]
      }.to_json
    end

    it "Returns an Array of Mailbox objects."  do
      stubs.post(client.api_url, expected_request_json) { [200, {}, mailboxes_json] }

      response = client.request do |request|
        described_class.get(request)
      end

      mailboxes = response.method_responses.first.arguments.list

      expect(response.method_responses.size).to eq(1)
      expect(mailboxes.size).to eq(7)
      expect(mailboxes.first).to be_a JMAP::Plugins::Mail::Mailbox
      stubs.verify_stubbed_calls
    end
  end
end
