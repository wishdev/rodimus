module Rodimus

  class Step
    include Observable
    include Observing # Steps observe themselves for run hooks
    include RuntimeLogging

    # The incoming data stream.  Can be anything that quacks like an IO
    attr_accessor :incoming

    # The outgoing data stream.  Can be anything that quacks like an IO
    attr_accessor :outgoing

    # Shared user-data accessible across all running transformation steps.
    # This is initialized by the Transformation when the step begins to run.
    attr_accessor :shared_data

    # The class used for managing the actual row data
    attr_writer :row_klass

    def initialize(*args)
      observers << self
      observers << Benchmark.new if Rodimus.configuration.benchmarking
      @outgoing = []
      @outgoing_slot = -1
      @row_klass = Row.dup
    end

    def close_descriptors
      [incoming, outgoing].flatten.reject(&:nil?).each do |descriptor|
        descriptor.close if descriptor.respond_to?(:close)
      end
    end

    # Override this for custom transformation functionality
    def process_row
      @row.output = @row.data
    end

    # Override this for custom output handling functionality per-row.
    def output_row
      if @row.output
        output = @row.format_output(@row.output)
        [ @row.outgoing_slot ].flatten.each { |outgoing_slot|
          outgoing[outgoing_slot].puts(output)
        }
      end
    end

    def run
      notify(self, :before_run)
      @row_count = 1
      incoming.each do |row|
        @row = @row_klass.new(row)
        notify(self, :before_row)
        process_row
        output_row
        Rodimus.logger.info(self) { "#{@row_count} rows processed" } if @row_count % 50000 == 0
        @row_count += 1
        notify(self, :after_row)
      end
      notify(self, :after_run)
    ensure
      close_descriptors
    end

    def add_outgoing(outgoing)
      @outgoing << outgoing
    end

    def set_outgoing(outgoing)
      @outgoing = [ outgoing ]
    end

    # Return Row unless otherwise defined
    def set_row_klass(row_klass)
      @row_klass = row_klass.dup
    end

    def set_formatter(formatter)
      @row_klass.set_formatter formatter
    end

    def to_s
      "#{self.class} connected to input: #{incoming || 'nil'} and output: #{outgoing || 'nil'}"
    end
  end
end
