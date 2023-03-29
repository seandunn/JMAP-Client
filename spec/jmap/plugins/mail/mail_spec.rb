# frozen_string_literal: true

require "spec_helper"

module JMAP
  module Plugins
    module Mail

      RSpec.describe "Fetching email in a mailbox:" do
        include_context "with a valid Client and Session:"

        # A client logs in for the first time. It first fetches the set of
        # Mailboxes. Now it will display the inbox to the user, which we will
        # presume has Mailbox id “fb666a55”. The inbox may be (very!) large, but
        # the user’s screen is only so big, so the client can just load the Threads
        # it needs to fill the screen and then load in more only when the user
        # scrolls.
        it "Displays user's top 30 inbox." do
          expected_json = JSON.parse File.read("spec/fixtures/mail/top-30-email-threads.json")

          request = client.request do |request|

            first_30_emails = Email.query(request) do |query|
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
                "threadId",
                "mailboxIds",
                "keywords",
                "hasAttachment",
                "from",
                "subject",
                "receivedAt",
                "size",
                "preview"
              ]
            end

          end

          expect(request).to be_a(JMAP::Plugins::Core::Request)
          expect(request.to_json).to include_json(expected_json)
        end
      end

    end
  end
end

