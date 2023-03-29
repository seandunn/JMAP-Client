# frozen_string_literal: true

module JMAP
  module Plugins
    module Mail
      class Email
        include JMAP::Plugins::Core::Queryable
        include JMAP::Plugins::Core::Getable
      end
    end
  end
end


