module Rodimus

  class Row
    include Formatter::Simple

    class << self
      def set_formatter(formatter)
        include_needed = false

        if @input_formatter != formatter && formatter.instance_methods.include?(:format_input)
          @input_formatter = formatter
          include_needed = true
        end

        if @output_formatter != formatter && formatter.instance_methods.include?(:format_output)
          @ouput_formatter = formatter
          include_needed = true
        end

        self.include(formatter) if include_needed
      end
    end

    attr_accessor :input, :output, :data

    # The current selection from the outgoing array
    attr_accessor :outgoing_slot

    def initialize(input)
      @input = input
      @data = self.format_input(input)
      @outgoing_slot = -1
    end
  end
end
