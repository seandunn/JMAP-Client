# frozen_string_literal: true

require "spec_helper"

JMAP.plugin("core")

RSpec.describe JMAP::Plugins::Core::Copyable do

  module TestModule
    class TestResource
      include JMAP::Plugins::Core::Copyable
    end
  end

  it "Generates expected JSON." do
    expected_json = [
      "TestResource/copy",
      {
        "fromAccountId": "x",
        "accountId": "y",
        "create": {
          "k5122": {
            "id": "a"
          }
        },
        "onSuccessDestroyOriginal": true
      }, "0"
    ]

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    copy_invocation = TestModule::TestResource.copy(request) do |copy|
      copy.from_account_id = "x"
      copy.account_id = "y"
      copy.create = { "k5122": { "id": "a" } }

      copy.on_success_destroy_original = true
    end

    expect(copy_invocation.name).to eq("TestResource/copy")
    expect(copy_invocation.method_call_id).to eq("0")
    expect(copy_invocation.to_json).to include_json(expected_json)
  end
end

