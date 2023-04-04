# frozen_string_literal: true

require "spec_helper"

module JMAP
  module Plugins
    module Mail
      RSpec.describe Mail  do
        context "Working with Requests and Responses:" do
          let(:expected_request_json) { JSON.parse File.read("spec/fixtures/mail/top-30-email-threads.json") }
          let(:response_json) {JSON.parse(File.read("spec/fixtures/mail/top-30-email-threads-response.json")) }

          it "Generates a Request to display the top 30 inbox threads." do
            capabilities = [JMAP::Plugins::Core::CAPABILITY, Mail::CAPABILITY]

            request = JMAP::Plugins::Core::Request.new("DUMMY-ACCOUNT-ID", capabilities)

            first_30_emails = Email.query(request) do |query|
              # TODO filters should be via a value object.
              query.filter = { "inMailbox": "fb666a55" }
              query.add_sort JMAP::Plugins::Core::Comparator.new(is_ascending: false, property: "receivedAt")
              query.collapse_threads = true
              query.position = 0
              query.limit = 30
              query.calculate_total = true
            end

            first_30_thread_ids = Email.get(request) do |get|
              get.ids = first_30_emails.result(path: "/ids")
              get.properties = [ Email::THREAD_ID ]
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

        context "Keeping in sync with an email server:" do
          let(:expected_request_json) { JSON.parse File.read("spec/fixtures/mail/staying_in_sync.json") }

          it "Generates the correct JSON request." do
            capabilities = [JMAP::Plugins::Core::CAPABILITY, Mail::CAPABILITY]

            request = JMAP::Plugins::Core::Request.new("DUMMY-ACCOUNT-ID", capabilities)

            # Fetch a list of mailbox ids that have changed
            changed_mailboxes = Mailbox.changes(request) do |changes|
              changes.since_state = "123" 
            end

            # Fetch any mailboxes that have been created
            Mailbox.get(request) do |get|
              get.ids = changed_mailboxes.result(path: "/created")
            end

            # Fetch any mailboxes that have been updated
            Mailbox.get(request) do |get|
              get.ids = changed_mailboxes.result(path: "/updated")
              get.properties = changed_mailboxes.result(path: "/updatedProperties")
            end

            # Get the updated result of our previous query
            updated_query_results = Email.query_changes(request) do |query_changes|
              query_changes.filter =  { "inMailbox": "mailbox1" }

              query_changes.add_sort( JMAP::Plugins::Core::Comparator.new(
                is_ascending: false,
                property: "receivedAt"
              ))

              # Should this be a back reference to changed_mailboxes?
              query_changes.since_query_state =  "123:0"
              query_changes.max_changes = 100
              query_changes.up_to_id = "fm1u313"
            end

            # Fetch the threadId for emails in the update query result
            thread_ids_for_updated_emails = Email.get(request) do |get|
              get.ids = updated_query_results.result(path: "/added")
              get.properties = [ Email::THREAD_ID ]
            end

            # Fetch threads for those emails
            threads_for_updated_emails = Thread.get(request) do |get|
              get.ids = thread_ids_for_updated_emails.result(path: "/list/*/threadId")
            end

            # Fetch emails for those threads
            Email.get(request) do |get|
              get.ids = threads_for_updated_emails.result(path: "/list/*/emailIds")
            end

            # Fetch a list of created/updated/deleted Emails
            Email.changes(request) do |changes|
              changes.since_state = "123"
              changes.max_changes = 30
            end

            # Fetch a list of created/udpated/deleted Threads
            Thread.changes(request) do |changes|
              changes.since_state = "123"
              changes.max_changes = 30
            end

            expect(request.to_json).to include_json(expected_request_json)
          end
        end

      end
    end
  end
end

