# frozen_string_literal: true

require "spec_helper"

RSpec.describe JMAP do
  context "Loading Plugins:" do
    context "From a Session:" do
      include_context "with a valid Client and Session:"

      it "Reads capabilities from Session and loads the matching Plugin." do
        # Start a faked session by calling client
        client

        expect(JMAP::PLUGINS.keys).to eq([:core, :mail])
        expect(JMAP::Plugins::Core).not_to be_nil
        expect(JMAP::Plugins::Mail).not_to be_nil
      end
    end
  end
end
