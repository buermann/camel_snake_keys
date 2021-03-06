require 'active_support/core_ext/hash'
require 'active_support/core_ext/string/inflections'

module CamelSnakeKeys
  [Hash,Array].each do |klass|
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
    def if_underscore(v)
      if v.is_a? Symbol
        v.to_s.underscore.to_sym
      elsif v.is_a? String
        v.underscore
      else
        v
      end
    end

    def if_camelize(v)
      if v.is_a? Symbol
        v.to_s.camelize(:lower).to_sym
      elsif v.is_a? String
        v.camelize(:lower)
      else
        v
      end
    end

    def snake_keys(data, indifference=false)
      if data.kind_of? Array
        data.map { |v| snake_keys(v, indifference) }
      elsif data.kind_of? Hash
        hash = Hash[data.sort_by {|k,_v| k =~ /_/ ? 0 : 1 }.map {|k, v| [if_underscore(k), snake_keys(v, indifference)] }]
        hash = hash.with_indifferent_access if indifference
        data.class == Hash ? hash : data.class.new(hash)
      else
        data
      end
    end

    def camel_keys(data, indifference=false)
      if data.kind_of? Array
        data.map { |v| camel_keys(v, indifference) }
      elsif data.kind_of? Hash
        hash = Hash[data.sort_by {|k,_v| k =~ /_/ ? 1 : 0 }.map {|k, v| [if_camelize(k), camel_keys(v, indifference)] }]
        hash = hash.with_indifferent_access if indifference
        data.class == Hash ? hash : data.class.new(hash)
      else
        data
      end
    end
  end
end


