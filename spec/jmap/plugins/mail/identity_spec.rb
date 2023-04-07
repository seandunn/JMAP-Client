# frozen_string_literal: true

require "spec_helper"

JMAP.plugin("mail")

RSpec.describe JMAP::Plugins::Mail::Identity do
  it "Generates the expected Invocation JSON." do
    expected_json = [
      "Identity/get", {
        "accountId": "TEST-USER-ID"
      }, "0"
    ] 

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])
    search_snippet = described_class.get(request)

    expect(search_snippet.to_json).to include_json(expected_json)
  end
end
