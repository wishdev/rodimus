require 'rodimus'
require 'csv'
require 'json'

Rodimus.configure do |config|
  config.benchmarking = true
end

class CsvInput < Rodimus::Step
  def before_run_set_incoming
    @incoming = CSV.open(File.expand_path('../worldbank-sample.csv', __FILE__))
    @incoming.readline # skip the headers
  end

  def process_row(row)
    row.to_json
  end
end

class FormattedText < Rodimus::Step
  def before_run_set_stdout
    set_outgoing STDOUT.dup
  end

  def process_row(row)
    data = JSON.parse(row)
    "In #{data.first} during #{data[1]}, CO2 emissions were #{data[2]} metric tons  per capita." 
  end
end

t = Rodimus::Transformation.new
s1 = CsvInput.new
s2 = FormattedText.new
t.steps << s1
t.steps << s2
t.run
puts "Transformation complete!"
