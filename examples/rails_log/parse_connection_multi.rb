class ParseConnection < Rodimus::Step
  attr_reader :current_event

  def initialize(*verbs)
    @slots = verbs.map(&:downcase)
    super
  end

  def process_row
    if @row.input =~ /^Started/
      parse_new_connection(@row.input)
    elsif @row.input =~ /^Completed/
      parse_end_connection(@row.input)

      @row.outgoing_slot = @slots.index(current_event[:verb].downcase) || -1
      @row.output = current_event
    end
  end

  private

  def parse_new_connection(row)
    @current_event = {}
    match_data = row.match(/^Started (\w+) \"(.+)\" for (.+) at (.+)$/)
    current_event[:verb] = match_data[1]
    current_event[:route] = match_data[2]
    current_event[:ip] = match_data[3]
    current_event[:time] = match_data[4]
  end

  def parse_end_connection(row)
    match_data = row.match(/^Completed ([0-9]+)/)
    current_event[:response] = match_data[1]
  end
end
