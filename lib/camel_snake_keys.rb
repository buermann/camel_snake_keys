require 'active_support/core_ext/hash'
require 'active_support/core_ext/string/inflections'
require 'hashie/mash'

module CamelSnakeKeys
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
        data.map { |v| snake_keys(v) }
      elsif data.kind_of? Hash
        hash = Hash[data.map {|k, v| [if_underscore(k), snake_keys(v)] }]
        if data.kind_of? Hashie::Mash
          Hashie::Mash.new( hash )
        elsif data.kind_of? HashWithIndifferentAccess || indifference
          HashWithIndifferentAccess.new( hash )
        else
          hash
        end
      else
        data
      end
    end

    def camel_keys(data, indifference=false)
      if data.kind_of? Array
        data.map { |v| camel_keys(v) }
      elsif data.kind_of? Hash
        hash = Hash[data.map {|k, v| [if_camelize(k), camel_keys(v)] }]
        if data.kind_of? Hashie::Mash
          Hashie::Mash.new( hash )
        elsif data.kind_of? HashWithIndifferentAccess || indifference
          HashWithIndifferentAccess.new( hash )
        else
          hash
        end
      else
        data
      end
    end
  end
end

module Enumerable
  def with_camel_keys(indifference=false)
    CamelSnakeKeys.camel_keys(self, indifference)
  end

  def with_snake_keys(indifference=false)
    CamelSnakeKeys.snake_keys(self, indifference)
  end
end
