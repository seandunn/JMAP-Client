# frozen_string_literal: true

require "spec_helper"

module JMAP
  module Plugins
    module Mail
      RSpec.describe Mail  do
        let(:expected_request_json) { JSON.parse File.read("spec/fixtures/mail/top-30-email-threads.json") }

        let(:response_json) {JSON.parse(File.read("spec/fixtures/mail/top-30-email-threads-response.json")) }

        context "Working with Requests and Responses:" do
          it "Generates a Request to display the top 30 inbox threads." do

            capabilities = [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ]

            request = Core::Request.new("DUMMY-ACCOUNT-ID", capabilities)

            first_30_emails = Email.query(request) do |query|
              # TODO filters should be via a value object.
              query.filter = { "inMailbox": "fb666a55" }
              query.add_sort Core::Comparator.new(is_ascending: false, property: "receivedAt")
              query.collapse_threads = true
              query.position = 0
              query.limit = 30
              query.calculate_total = true
            end

            first_30_thread_ids = Email.get(request) do |get|
              get.ids = first_30_emails.result(path: "/ids")
              get.properties = [ "threadId" ]
            end

            first_30_threads = Thread.get(request) do |get|
              get.ids = first_30_thread_ids.result(path: "/list/*/threadId")
            end

            Email.get(request) do |get|
              get.ids = first_30_threads.result(path: "/list/*/emailIds")

              get.properties = [
                Email::THREAD_ID,
                Email::MAILBOX_IDS,
                Email::KEYWORDS,
                Email::HAS_ATTACHMENT,
                Email::FROM,
                Email::SUBJECT,
                Email::RECEIVED_AT,
                Email::SIZE,
                Email::PREVIEW
              ]
            end

            expect(request).to be_a(JMAP::Plugins::Core::Request)
            expect(request.to_json).to include_json(expected_request_json)
          end

          it "Parses a Response for the top 30 inbox threads." do
            response = JMAP::Plugins::Core::Response.new(response_json)
            method_responses = response.method_responses

            aggregate_failures do
              expect(method_responses[0].name).to eq("Email/query")

              expect(method_responses[1].name).to eq("Email/get")
              expect(method_responses[1].arguments["list"][0]).to be_an(Email)

              expect(method_responses[2].name).to eq("Thread/get")
              expect(method_responses[2].arguments["list"][0]).to be_an(Thread)

              expect(method_responses[3].name).to eq("Email/get")
              expect(method_responses[3].arguments["list"][0]).to be_an(Email)
            end
          end
        end

      end
    end
  end
end

