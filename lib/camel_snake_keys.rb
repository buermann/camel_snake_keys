require 'active_support'
require 'active_support/core_ext'

module CamelSnakeKeys
  [Hash, Array].each do |klass|
    refine klass do
      def with_camel_keys(indifference=false)
        CamelSnakeKeys.camel_keys(self, indifference)
      end

      def with_snake_keys(indifference=false)
        CamelSnakeKeys.snake_keys(self, indifference)
      end
    end
  end

  class << self
    def if_underscore(obj)
      case obj
      when Symbol
        obj.to_s.underscore.to_sym
      when String
        obj.underscore
      else
        obj
      end
    end

    def if_camelize(obj)
      case obj
      when Symbol
        obj.to_s.camelize(:lower).to_sym
      when String
        obj.camelize(:lower)
      else
        obj
      end
    end

    def snake_keys(data, indifference=false)
      case data
      when Array
        data.map { |v| snake_keys(v, indifference) }
      when Hash
        hash = data.sort_by {|k, _v| k =~ /_/ ? 0 : 1 }.map {|k, v| [if_underscore(k), snake_keys(v, indifference)] }.to_h
        hash = hash.with_indifferent_access if indifference
        data.instance_of?(Hash) ? hash : data.class.new(hash)
      else
        data
      end
    end

    def camel_keys(data, indifference=false)
      case data
      when Array
        data.map { |v| camel_keys(v, indifference) }
      when Hash
        hash = data.sort_by {|k, _v| k =~ /_/ ? 1 : 0 }.map {|k, v| [if_camelize(k), camel_keys(v, indifference)] }.to_h
        hash = hash.with_indifferent_access if indifference
        data.instance_of?(Hash) ? hash : data.class.new(hash)
      else
        data
      end
    end
  end
end
