$trace ||= TracePoint.new(:call, :c_call, :b_call, :raise) do |tp|
  case tp.event
  when :call, :c_call, :b_call
    defined_class = tp.defined_class
    if tp.defined_class.name == nil
      puts "#{tp.event.to_s} #{tp.self.name}.#{tp.method_id} (#{tp.path}:#{tp.lineno})"
    else
      puts "#{tp.event.to_s} #{tp.defined_class.name}##{tp.method_id} (#{tp.path}:#{tp.lineno})"
    end
  end
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
$trace.enable
t.instance_method
Test.class_method
$trace.disable