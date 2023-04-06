# frozen_string_literal: true

require "spec_helper"

JMAP.plugin("core")

RSpec.describe JMAP::Plugins::Core::Settable do

  module TestModule
    class TestResource
      include JMAP::Plugins::Core::Settable
    end
  end

  it "Generates expected JSON." do
    expected_json = [
      "TestResource/set", {
        "accountId": "TEST-USER-ID",
        "ifInState": "10324",
        "update": {
          "a": {
            "id": "a",
            "title": "Practise Piano",
            "keywords": {
              "music": true,
              "beethoven": true,
              "chopin": true,
              "liszt": true,
              "rachmaninov": true
            },
            "neuralNetworkTimeEstimation": 360
          }
        }
      },
      "0"
    ]

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    set_invocation = TestModule::TestResource.set(request) do |set|
      set.if_in_state = "10324"
      set.update = {
          "a": {
            "id": "a",
            "title": "Practise Piano",
            "keywords": {
              "music": true,
              "beethoven": true,
              "chopin": true,
              "liszt": true,
              "rachmaninov": true
            },
            "neuralNetworkTimeEstimation": 360
          }
        }

    end

    expect(set_invocation.name).to eq("TestResource/set")
    expect(set_invocation.method_call_id).to eq("0")
    expect(set_invocation.to_json).to include_json(expected_json)
  end
end

