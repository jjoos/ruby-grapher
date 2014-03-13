require 'rspec'
require_relative '../lib/tracer.rb'

def test_function
  true
end

def test_function_that_accepts_block &block
  block.call

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

def recursive_function(n)
  return if n.zero?
  recursive_function(n-1)
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
        test_function
      end

      expect(register.calls).to eq [{
          from: {
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 63
          },
          to: {
            klass: 'Object',
            method: :test_function,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 4
          },
          count: 1
      }]
    end

    it 'two calls' do
      register = Tracer.record do
        test_function; test_function
      end

      expect(register.calls).to eq [{
          from: {
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 85
          },
          to: {
            klass: 'Object',
            method: :test_function,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 110
          }, to: {
            klass: 'TestClass',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 15
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 132
          }, to: {
            klass: 'TestClass',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 15
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 155
          }, to: {
            klass: 'TestClass',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 19
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 176
          }, to: {
            klass: 'TestClass',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 19
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 201
          }, to: {
            klass: 'TestModule',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 25
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 224
          }, to: {
            klass: 'TestModule',
            method: :instance_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 25
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 247
          }, to: {
            klass: 'TestModule',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 29
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
            klass: nil,
            method: nil,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 268
          }, to: {
            klass: 'TestModule',
            method: :class_method,
            path: '/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb',
            lineno: 29
          },
          count: 2
      }]
    end
  end

  context 'recursive function' do
    it 'gets called three times' do
      register = Tracer.record do
        recursive_function 3
      end

      expect(register.calls).to eq [{
          from: {
            klass: nil,
            method: nil,
            path: "/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb",
            lineno: 291
          }, to: {
            klass: "Object",
            method: :recursive_function,
            path: "/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb",
            lineno: 44
          },
          count: 1
        }, {
          from: {
            klass: "Object",
            method: :recursive_function,
            path: "/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb",
            lineno: 45
          }, to: {
            klass: "Fixnum",
            method: :zero?
          },
          count: 4
        }, {
          from: {
            klass: "Object",
            method: :recursive_function,
            path: "/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb",
            lineno: 46
          }, to: {
            klass: "Object",
            method: :recursive_function,
            path: "/Users/jan/dev/ruby_grapher/spec/tracer_spec.rb",
            lineno: 44
          },
          count: 3
      }]
    end
  end
end