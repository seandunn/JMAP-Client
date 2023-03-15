# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core::Request do
  it "Transforms into standard JMAP request JSON." do
    invocation = JMAP::Plugins::Core::Invocation.new(
      name: "Mailbox/get",
      arguments: { "accountId": "DUMMY-ACCOUNT-ID", "ids": nil }
    )

    request = described_class.new(
      ["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"]
    )

    request << invocation

    expected_json = {
      "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
      "methodCalls": [
        [ "Mailbox/get", { "accountId": "DUMMY-ACCOUNT-ID", "ids": nil }, 0 ]
      ]
    }.to_json

    expect(request.to_json).to eq(expected_json)
  end
end
