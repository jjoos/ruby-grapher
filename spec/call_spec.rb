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
      register = Tracer.record do

      end

      expect(register.calls).to eq []
    end
  end

  context 'simpel method' do
    it 'simple call' do
      register = Tracer.record do
        test_method
      end

      expect(register.calls).to eq [{
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
          },
          count: 1
      }]
    end

    it 'two calls' do
      register = Tracer.record do
        test_method; test_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 73
          },
          to: {
            klass: 'Object',
            method: :test_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 4
          },
          count: 2
      }]
    end
  end

  context 'instance method' do
    it 'simple call' do
      test_class = TestClass.new
      register = Tracer.record do
        test_class.instance_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 98
          }, to: {
            klass: 'TestClass',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 9
          },
          count: 1
      }]
    end

    it 'two calls' do
      test_class = TestClass.new
      register = Tracer.record do
        test_class.instance_method; test_class.instance_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 120
          }, to: {
            klass: 'TestClass',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 9
          },
          count: 2
      }]
    end
  end

  context 'class method' do
    it 'simple call' do
      register = Tracer.record do
        TestClass.class_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 143
          }, to: {
            klass: 'TestClass',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 13
          },
          count: 1
      }]
    end

    it 'two calls' do
      register = Tracer.record do
        TestClass.class_method; TestClass.class_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 164
          }, to: {
            klass: 'TestClass',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 13
          },
          count: 2
      }]
    end
  end

  context 'module instance method' do
    it 'simple call' do
      klass = Class.new.extend(TestModule)

      register = Tracer.record do
        klass.instance_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 189
          }, to: {
            klass: 'TestModule',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 19
          },
          count: 1
      }]
    end

    it 'two calls' do
      klass = Class.new.extend(TestModule)

      register = Tracer.record do
        klass.instance_method; klass.instance_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 212
          }, to: {
            klass: 'TestModule',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 19
          },
          count: 2
      }]
    end
  end

  context 'module class method' do
    it 'simple call' do
      register = Tracer.record do
        TestModule.class_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 235
          }, to: {
            klass: 'TestModule',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 23
          },
        count: 1
      }]
    end

    it 'two calls' do
      register = Tracer.record do
        TestModule.class_method; TestModule.class_method
      end

      expect(register.calls).to eq [{
          from: {
            klass: ':block',
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 256
          }, to: {
            klass: 'TestModule',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/call_spec.rb',
            lineno: 23
          },
        count: 2
      }]
    end
  end
end