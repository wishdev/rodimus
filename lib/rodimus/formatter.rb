module Rodimus
  module Formatter

    module InOutFormatter
      def self.included(base)
        base.extend(MethodMethods)
      end

      # Ugly but it saves more ugliness
      def format_input(*args); nil; end
      def format_output(*args); nil; end

      module MethodMethods
        def included(base)
          base.include Object.const_get(self.to_s + "In")
          base.include Object.const_get(self.to_s + "Out")
        end
      end
    end
  end
end

require_relative 'formatter/simple'
require_relative 'formatter/json'
