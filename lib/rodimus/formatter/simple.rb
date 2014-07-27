module Rodimus
  module Formatter

    module SimpleIn
      def format_input(data)
        data
      end
    end

    module SimpleOut
      def format_output(data)
        data
      end
    end

    module Simple
      include InOutFormatter
    end
  end
end
