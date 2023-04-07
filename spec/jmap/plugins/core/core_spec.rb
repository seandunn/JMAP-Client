# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core do
  it "Can send a generic echo message to the server."  do
    expected_json = [
      "Core/echo",
      { message: "TEST-MESSAGE" },
      "0"
    ].to_json

    request = JMAP::Plugins::Core::Request.new("TEST-USER-ID", ["TEST-CAPABILITY"])

    echo_invocation = described_class.echo(request) do |echo|
      echo.message = "TEST-MESSAGE"
    end

    expect(echo_invocation.name).to eq("Core/echo")
    expect(echo_invocation.method_call_id).to eq("0")
    expect(echo_invocation.to_json).to eq(expected_json)
  end
end
