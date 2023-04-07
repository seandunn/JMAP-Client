# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      # An Identity object stores information about an email address or domain
      # the user may send from.
      class Identity
        include JMAP::Plugins::Core::Gettable
        include JMAP::Plugins::Core::Changeable
        include JMAP::Plugins::Core::Settable
      end
    end
  end
end

