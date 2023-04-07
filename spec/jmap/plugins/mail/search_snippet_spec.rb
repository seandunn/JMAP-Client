# frozen_string_literal: true

require "spec_helper"

JMAP.plugin("mail")

RSpec.describe JMAP::Plugins::Mail::SearchSnippet do
  it "Generates the expected Invocation JSON." do
    expected_json = [
      "SearchSnippet/get", {
        "accountId": "TEST-USER-ID",
        "filter": {
          "text": "foo"
        },
        "emailIds": [
          "M44200ec123de277c0c1ce69c",
          "M7bcbcb0b58d7729686e83d99",
          "M28d12783a0969584b6deaac0"
        ]
      }, "0"
    ] 

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    search_snippet = described_class.get(request) do |get|
      get.filter = { text: "foo" }
      get.email_ids = [
        "M44200ec123de277c0c1ce69c",
        "M7bcbcb0b58d7729686e83d99",
        "M28d12783a0969584b6deaac0"
      ]
    end

    expect(search_snippet.to_json).to include_json(expected_json)
  end
end
