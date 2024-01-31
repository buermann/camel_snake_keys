# frozen_string_literal: true

# Convert the keys of hashes in nested structures to camel or snake case.
module CamelSnakeKeys
  [Hash, Array].each do |klass|
    refine klass do
      def with_camel_keys
        CamelSnakeKeys.camel_keys(self)
      end

      def with_snake_keys
        CamelSnakeKeys.snake_keys(self)
      end
    end
  end

  class << self
    def camelcase(obj)
      string = +obj.to_s # unfreeze whatever it might be with a leading +
      string.sub!(/^([A-Z])/) { $1.downcase }
      string.gsub!(/_([a-z\d])/) { $1.capitalize }
      string
    end

    def snakecase(obj)
      string    = +obj.to_s
      string[0] = string[0].downcase if string[0]
      string.gsub!(/([A-Z])/) { "_#{$1}" }
      string.downcase!
      string
    end

    def if_underscore(obj)
      case obj
      when Symbol
        snakecase(obj.to_s).to_sym
      when String
        snakecase(obj)
      else
        obj
      end
    end

    def if_camelize(obj)
      case obj
      when Symbol
        camelcase(obj.to_s).to_sym
      when String
        camelcase(obj)
      else
        obj
      end
    end

    def snake_keys(data)
      case data
      when Array
        data.map { |v| snake_keys(v) }
      when Hash
        hash = data.sort_by { |k, _v| k.to_s =~ /_/ ? 0 : 1 }.to_h { |k, v| [if_underscore(k), snake_keys(v)] }
        data.instance_of?(Hash) ? hash : data.class.new(hash)
      else
        data
      end
    end

    def camel_keys(data)
      case data
      when Array
        data.map { |v| camel_keys(v) }
      when Hash
        hash = data.sort_by { |k, _v| k.to_s =~ /_/ ? 1 : 0 }.to_h { |k, v| [if_camelize(k), camel_keys(v)] }
        data.instance_of?(Hash) ? hash : data.class.new(hash)
      else
        data
      end
    end
  end
end
