# frozen_string_literal: true

RSpec.shared_context "with a valid Client and Session:" do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:session_json) { JSON.parse(File.read("spec/fixtures/core/session.json")) }

  let(:client) do
    stubs.get("/jmap/session") do
      [ 200, { 'Content-Type': 'application/javascript' }, session_json ]
    end

    JMAP.connect(
      url: "https://api.email_provider.com/jmap/session" ,
      bearer_token: "TEST-BEARER-TOKEN" ,
      adapter: :test,
      stubs: stubs
    )
  end 
end
