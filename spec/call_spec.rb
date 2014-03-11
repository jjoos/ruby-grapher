require 'rspec'
require_relative '../lib/tracer.rb'

def test_method
  true
end

describe 'trace calls' do
  it 'empty block' do
    calls = Tracer.record do

    end

    expect(calls).to eq []
  end

  it 'block with simpel method call' do
    calls = Tracer.record do
      test_method
    end

    expect(calls).to eq [{
      from: {
        klass: ':block',
        method: nil,
        path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
        lineno: 18
      },
      to: {
        klass: 'Object',
        method: :test_method,
        path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
        lineno: 4
      }
    }]
  end
end