# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core::Queryable do
  module TestModule
    class TestResource
      include JMAP::Plugins::Core::Queryable
    end
  end

  include_context "with a valid Client and Session:"

  it "Generates expected JSON" do
    expected_json = [
      "TestResource/query",
      {
        accountId: "TEST-USER-ID",
        calculateTotal: true,
        collapseThreads: true,
        filter: { inMailbox: "fb666a55" },
        limit: 30,
        position: 0,
        sort: [{
          isAscending: false,
          property: "receivedAt"
        }]
      },
      "0"
    ].to_json

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    invocation = TestModule::TestResource.query(request) do |query|
      query.filter = { "inMailbox": "fb666a55" }
      query.add_sort(isAscending: false, property: "receivedAt")
      query.collapse_threads = true
      query.position = 0
      query.limit = 30
      query.calculate_total = true
    end

    expect(invocation.name).to eq("TestResource/query")
    expect(invocation.method_call_id).to eq("0")
    expect(invocation.to_json).to eq(expected_json)
  end

end
