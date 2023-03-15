# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP::Plugins::Core::Client do
  let(:url) {  "https://api.email_provider.com/jmap/session" }
  let(:token) { "TEST-BEARER-TOKEN" }
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:session_json) { JSON.parse(File.read("spec/fixtures/core/session.json")) }

  let(:client) { described_class.new(url: url, bearer_token: token, adapter: :test, stubs: stubs) } 


  it "Returns a Session object when initialized with a URL and bearer token." do
    stubs.get("/jmap/session") do
      [ 200, { 'Content-Type': 'application/javascript' }, session_json ]
    end

    expect(client.session.username).to eq("test_user@email_provider.com")
  end
end
