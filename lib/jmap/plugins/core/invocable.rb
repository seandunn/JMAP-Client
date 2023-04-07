# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Invocable
        def invoke(method_name, request)
          klass_name = pascalize(method_name)
          arguments_class = self.const_get(klass_name)
          arguments_instance = arguments_class.new(request.account_id)

          yield arguments_instance if block_given?

          short_resource_name = self.name.split("::").last

          invocation = Invocation.new(
            name: "#{short_resource_name}/#{camelize method_name}",
            arguments: arguments_instance.as_json
          )

          # Adding the invocation to the request sets the its method_call_id.
          request << invocation

          # Return the invocation so it can be used for back references in
          # the response.
          invocation
        end

        def pascalize(string)
          string.to_s.split("_").map!(&:capitalize).join
        end

        def camelize(string)
          (head, *rest) = string.to_s.split("_")
          head.concat rest.map!(&:capitalize).join
        end
      end
    end
  end
end
