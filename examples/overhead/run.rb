require 'rodimus'

class Simple < Rodimus::Step
  def initialize(count)
    super()
    @count = count
    @incoming = (1..count.to_i).to_a
  end

  def to_s
    "#{self.class} connected to input: Array of #{@count} items"
  end
end

class File13 < Rodimus::Step
  def initialize
    super
    set_outgoing File.open(File::NULL, "w")
  end
end

t = Rodimus::Transformation.new
step1 = Simple.new(ARGV[0])
step2 = File13.new
t.steps << step1
t.steps << step2
t.run

puts "Transformation complete!"
