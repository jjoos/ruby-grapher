require 'singleton'

class TraceCollector
  include Singleton

  def initialize
    @calls = {}
  end

  def collect(tp)
    klass = tp.self.class.name
    klass = klass ? klass : "NilClass"
    items = @calls.dup
    items[klass] ||= {}
    items[klass][tp.method_id] ||= 0
    items[klass][tp.method_id] += 1
    @calls = items
  end

  def self.method_missing(name, *args, &block)
    instance.send(name, *args, &block)
  end

  def each(&block)
    @calls.each(&block)
  end

end

tracers = []
[:c_call, :call].each do |event|
  tracers << TracePoint.new(event) do |tp|
    TraceCollector.collect(tp)
  end
end
tracers.map(&:enable)

at_exit do
  tracers.map(&:disable)

  totals = {}
  longest_name_size = 0

  TraceCollector.each do |klass, methods|
    if klass && klass.length > longest_name_size
      longest_name_size = klass.length
    end

    totals[klass] ||= 0
    puts "#{klass}:"
    methods = methods.sort_by {|k, v| v}.reverse
    methods.each do |method, count|
      totals[klass] += count
      printf "\t%-30s %s\n", method, count
    end
    puts "\n"
  end
  puts "-------------"
  puts "Totals:\n"
  totals = totals.sort_by {|k, v| v}.reverse
  total_calls = 0
  totals.each do |klass, total|
    total_calls += total
    printf "\t%-#{longest_name_size}s %s\n", klass, total
  end

  puts "\n\n Total Method Calls: #{total_calls}"
end

class Xxxx
  def self.test
    puts 'side effect'
  end
end

class Test
  def instance_method
    Test.class_method
  end

  def self.class_method
    Xxxx.test
    Kernel.puts 'test'
    true
  end
end

t = Test.new
t.instance_method
Test.class_method