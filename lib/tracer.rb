require 'call_register.rb'

class Tracer
  def self.record &block
    calls = CallRegister.new
    location_stack = []
    line_tracer = TracePoint.new(:line) do |tp|
      if tp.self != nil && tp.self.respond_to?(:name)
        called_class = tp.self.name
      elsif tp.defined_class != nil
        called_class = tp.defined_class.name
      else
        called_class = nil
      end

      location = location_stack.pop.dup
      location[:path] = tp.path
      location[:klass] = called_class
      location[:method] = tp.method_id
      location[:lineno] = tp.lineno
      location_stack << location
    end

    tracer = TracePoint.new(:call, :c_call, :b_call, :b_return, :return, :raise) do |tp|
      called_class = ''

      # manage location stack
      case tp.event
      when :call, :c_call, :b_call
        if tp.event == :b_call
          called_class = ':block'
        elsif tp.defined_class.name == nil
          called_class = tp.self.name
        else
          called_class = tp.defined_class.name
        end

        location = {
          klass: called_class,
          method: tp.method_id
        }

        if tp.event != :c_call
          location = location.merge({
              path: tp.path,
              lineno: tp.lineno
          })
        end

        location_stack << location
      when :b_return, :return, :c_return, :raise
        location_stack = location_stack[0...-1]
      end

      # register call
      if [:call, :c_call].include?(tp.event) && location_stack.length > 1
        if location_stack[-1][:klass] != 'TracePoint' && location_stack[-1][:method] != :disable
          calls.add({
              from: location_stack[-2],
              to: location_stack[-1]
          })
        end
      end
    end

    tracer.enable
    line_tracer.enable
    begin
      yield
    ensure
      line_tracer.disable
      tracer.disable
    end

    calls.finalize

    calls
  end
end
