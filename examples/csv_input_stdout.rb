require 'rodimus'
require 'csv'

Rodimus.configure do |config|
  config.benchmarking = true
end

class CsvInput < Rodimus::Step
  def before_run_set_incoming
    @incoming = CSV.open(File.expand_path('../worldbank-sample.csv', __FILE__))
    @incoming.readline # skip the headers
  end
end

class FormattedText < Rodimus::Step
  def before_run_set_stdout
    add_outgoing STDOUT.dup
  end

  def process_row
    @row.output = "In #{@row.data.first} during #{@row.data[1]}, CO2 emissions were #{@row.data[2]} metric tons  per capita."
  end
end

t = Rodimus::Transformation.new
s1 = CsvInput.new
s1.set_formatter(Rodimus::Formatter::JsonOut)
s2 = FormattedText.new
s2.set_formatter(Rodimus::Formatter::JsonIn)
t.steps << s1
t.steps << s2
t.run
puts "Transformation complete!"
