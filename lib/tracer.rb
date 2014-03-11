class Tracer
  def self.record &block
    calls = []
    location_stack = []
    tracer = TracePoint.new(:call, :c_call, :b_call, :b_return, :return, :raise) do |tp|
      called_class = ''

      # manage location stack
      case tp.event
      when :call, :c_call, :b_call
        # todd add to location stack
        if tp.event == :b_call
          called_class = ':block'
        elsif tp.defined_class.name == nil
          called_class = tp.self.name
        else
          called_class = tp.defined_class.name
        end
        location_stack << ({
            klass: called_class,
            method: tp.method_id,
            path: tp.path,
            lineno: tp.lineno
        })
      when :b_return, :return, :c_return, :raise
        location_stack = location_stack[0...-1]
      when :line
        location_stack.last[:called_path] = tp.path
        location_stack.last[:called_lineno] = tp.lineno
      end

      # register dependency
      if [:call, :c_call].include?(tp.event) && location_stack.length > 1
         calls << ({
          from: location_stack[-2],
          to: location_stack[-1]
        })
      end
    end

    tracer.enable
    begin
      yield
    ensure
      tracer.disable
    end

    calls
  end
end
