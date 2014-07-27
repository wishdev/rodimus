require 'rodimus'
require_relative 'log_input'
require_relative 'parse_connection_multi'
require_relative 'file_output'

log = File.expand_path('../rails_example.log', __FILE__)
t = Rodimus::Transformation.new
step1 = LogInput.new(log)
step2 = ParseConnection.new('GET', 'POST', 'DEFAULT')
step2.set_formatter(Rodimus::Formatter::JsonOut)
outputs = ['GET', 'POST', 'DEFAULT'].map { |verb|
  step = FileOutput.new(verb)
  step.set_formatter(Rodimus::Formatter::JsonIn)
  step
}
t.steps << step1
t.steps << step2
t.steps << outputs
t.run

puts "Transformation complete!"
