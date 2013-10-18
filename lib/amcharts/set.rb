require 'active_support/core_ext/module/delegation'

module AmCharts
  class Set
    include Enumerable

    delegate :empty?, :size, :each, to: :@set

    def initialize(klass, set = [])
      @klass = klass.is_a?(Class) ? klass : klass.class
      @set = set
    end

    class << self
      alias_method :[], :new
    end

    def [](item)
      item = item.to_sym
      detect{ |i| i.name.to_sym == item }
    end

    def new(*args, &block)
      @set << @klass.new(*args, &block)
    end

    def <<(obj)
      raise ArgumentError, "can only add #{@klass.name} objects" unless obj.is_a?(@klass)
      @set << obj
    end

    def except(*items)
      items.map!(&:to_sym)
      self.class.new(reject{ |i| items.include?(i.name.to_sym) })
    end

    def ==(other)
      return @set == other if other.is_a?(Array)
      super
    end
  end
end