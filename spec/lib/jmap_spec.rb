# frozen_string_literal: true

require "spec_helper"
require "faraday"

RSpec.describe JMAP::Session do
  let(:url) {  "https://api.email_provider.com/jmap/session" }
  let(:bearer_token) { "TEST-BEARER-TOKEN" }
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:session) do
    JMAP::Session.new(url: url, bearer_token: bearer_token) do |builder|
      builder.adapter :test, stubs
    end
  end 

  let(:session_json) { JSON.parse(File.read("spec/fixtures/session.json")) }

  it "Returns a Session object when initialized with a URL and bearer token." do
    stubs.get("/jmap/session") do
      [
        200,
        { 'Content-Type': 'application/javascript' },
        session_json
      ]
    end

    expect(session.username).to eq("test_user@example.com")
  end
end
