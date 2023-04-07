# frozen_string_literal: true

module JMAP
  module Plugins
    module Core
      module Invocable
        def invoke(method_name, request)
          # e.g. Email, Mailbox, etc.
          short_resource_name = self.name.split("::").last

          # The class of arguments to the Invocable used to carry out the
          # specific JMAP method.
          arguments_class = find_arguments_class(short_resource_name, method_name)

          arguments_instance = arguments_class.new(request.account_id)

          yield arguments_instance if block_given?

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

        # The type of arguments used by an invocation can be either specific to
        # the JMAP and method or just defaulted for the JMAP method used.
        #
        # For example, a SearchSnippet/get will have extra arguments which are
        # not included in a generic Foo/get.
        def find_arguments_class(short_resource_name, method_name)
          # e.g. Get, Set, Query, etc.
          method_arguments_class_name = pascalize(method_name)

          obj_arguments_class_name = :"#{short_resource_name}#{method_arguments_class_name}"

          if self.constants.include?(obj_arguments_class_name)
            self.const_get(obj_arguments_class_name)
          else
            # If it doesn't exist then fall back to the method specific
            # arguments class.
            self.const_get(method_arguments_class_name)
          end
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
