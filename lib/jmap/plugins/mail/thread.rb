# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail

      #  A Thread is simply a flat list of Emails, ordered by date. Every Email
      #  MUST belong to a Thread, even if it is the only Email in the Thread.
      class Thread < OpenStruct
        include JMAP::Plugins::Core::Getable
      end

    end
  end
end


