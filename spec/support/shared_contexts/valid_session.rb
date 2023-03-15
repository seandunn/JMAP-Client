# frozen_string_literal: true

RSpec.shared_context "with a valid Client and Session:" do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:session_json) { JSON.parse(File.read("spec/fixtures/core/session.json")) }

  let(:client) do
    client = JMAP.connect(
      url: "https://api.email_provider.com/jmap/session" ,
      bearer_token: "TEST-BEARER-TOKEN" ,
      adapter: :test,
      stubs: stubs
    )

    allow(client).to receive(:session).and_return(JMAP::Core::Session.new(session_json))
    client
  end 
end
