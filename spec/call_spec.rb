require 'rspec'
require_relative '../lib/tracer.rb'

def test_method
  true
end

class TestClass
  def instance_method
    true
  end

  def self.class_method
    true
  end
end

module TestModule
  def instance_method
    true
  end

  def self.class_method
    true
  end

  class TestClassInModule
    def instance_method_in_class_in_module
      true
    end

    def self.class_method_in_class_in_module
      true
    end
  end
end

describe '#record' do
  context 'empty block' do
    it 'no calls' do
      calls = Tracer.record do

      end

      expect(calls).to eq []
    end
  end

  context 'simpel method' do
    it 'simple call' do
      calls = Tracer.record do
        test_method
      end

      expect(calls).to eq [{
        from: {
          klass: ':block',
          method: nil,
          path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
          lineno: 51
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

  context 'instance method' do
    it 'simple call' do
      test_class = TestClass.new
      calls = Tracer.record do
        test_class.instance_method
      end

      expect(calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 75
          }, to: {
            klass: 'TestClass',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 9
          }
      }]
    end
  end

  context 'class method' do
    it 'simple call' do
      calls = Tracer.record do
        TestClass.class_method
      end

      expect(calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 97
          }, to: {
            klass: 'TestClass',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 13
          }
      }]
    end
  end

  context 'module instance method' do
    it 'simple call' do
      klass = Class.new.extend(TestModule)

      calls = Tracer.record do
        klass.instance_method
      end

      expect(calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 121
          }, to: {
            klass: 'TestModule',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 19 }}]
    end
  end

  context 'module class method' do
    it 'simple call' do
      calls = Tracer.record do
        TestModule.class_method
      end

      expect(calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 141
          }, to: {
            klass: 'TestModule',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 23
      }}]
    end
  end
end