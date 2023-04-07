# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core::Gettable do
  include_context "with a valid Client and Session:"

  module TestModule
    class TestResource
      include JMAP::Plugins::Core::Queryable
      include JMAP::Plugins::Core::Gettable
    end
  end

  it "Generates expected JSON" do
    expected_json = [
      "TestResource/get",
      {
        accountId: "TEST-USER-ID",
        ids: ["TEST-ID1", "TEST-ID2"],
        properties: [ "threadId" ]
      },
      "0"
    ].to_json

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    get_invocation = TestModule::TestResource.get(request) do |get|
      get.ids = ["TEST-ID1", "TEST-ID2"]
      get.properties = [ "threadId" ]
    end

    expect(get_invocation.name).to eq("TestResource/get")
    expect(get_invocation.method_call_id).to eq("0")
    expect(get_invocation.to_json).to eq(expected_json)
  end

  it "Reuses the results of a previous invocation." do
    expected_json = [
      "TestResource/get",
      {
        accountId: "TEST-USER-ID",

        "#ids": {
          resultOf: "0",
          name: "TestResource/query",
          path: "/ids"
        },
        properties: [ "threadId" ]
      },
      "1"
    ].to_json

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    query_inovcation = TestModule::TestResource.query(request) do |query|
      query.add_sort(ascending: false, property: "receivedAt")
    end


    get_invocation = TestModule::TestResource.get(request) do |get|
      get.ids = query_inovcation.result(path: "/ids")
      get.properties = [ "threadId" ]
    end

    expect(get_invocation.name).to eq("TestResource/get")
    expect(get_invocation.method_call_id).to eq("1")
    expect(get_invocation.to_json).to eq(expected_json)
  end

end


