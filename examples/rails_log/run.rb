require 'rodimus'
require_relative 'log_input'
require_relative 'parse_connection'
require_relative 'file_output'

log = File.expand_path('../rails_example.log', __FILE__)
t = Rodimus::Transformation.new
step1 = LogInput.new(log)
step2 = ParseConnection.new
step2.set_formatter(Rodimus::Formatter::JsonOut)
step3 = FileOutput.new
step3.set_formatter(Rodimus::Formatter::JsonIn)
t.steps << step1
t.steps << step2
t.steps << step3
t.run

puts "Transformation complete!"
