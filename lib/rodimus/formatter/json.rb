require 'multi_json'

module Rodimus
  module Formatter

    module JsonIn
      def format_input(data)
        MultiJson.load(data)
      end

    end

    module JsonOut
      def format_output(data)
        MultiJson.dump(data)
      end
    end

    module Json
      include InOutFormatter
    end
  end
end
