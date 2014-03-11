require 'digest/sha1'

class CallRegister
  attr_reader :calls

  def initialize
    @calls = []
    @call_count = {}
  end

  def add(call)
    hash = Digest::SHA1.hexdigest call.to_s
    if @call_count.key? hash
      @call_count[hash] += 1
    else
      @call_count[hash] = 1
      @calls << call
    end
  end

  def finalize
    @calls = @calls.map do |call|
      hash = Digest::SHA1.hexdigest call.to_s
      call.merge({count: @call_count[hash]})
    end
  end
end