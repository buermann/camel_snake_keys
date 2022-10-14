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
    def camelize(obj)
      return unless obj

      str = obj.to_s.split(/[-_]+/).map {|w| w[0].upcase! + w[1..] }.join
			str[0].downcase! + str[1..]
    end

   def underscore(obj)
     return unless obj

     str = obj.to_s.gsub('-','_').split(/([A-Z])/).map {
       |syl| syl =~ /^[A-Z]/ ? "_#{syl.downcase!}" : syl
     }.join.sub(/^_/,'')
   end

   def if_underscore(obj)
     case obj
     when Symbol
       underscore(obj.to_s).to_sym
     when String
       underscore(obj)
     else
       obj
     end
   end

   def if_camelize(obj)
     case obj
     when Symbol
       camelize(obj.to_s).to_sym
     when String
       camelize(obj)
     else
       obj
     end
   end

   def snake_keys(data)
     case data
     when Array
       data.map { |v| snake_keys(v) }
     when Hash
       hash = data.sort_by {|k, _v| k =~ /_/ ? 0 : 1 }.map {|k, v| [if_underscore(k), snake_keys(v)] }.to_h
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
       hash = data.sort_by {|k, _v| k =~ /_/ ? 1 : 0 }.map {|k, v| [if_camelize(k), camel_keys(v)] }.to_h
       data.instance_of?(Hash) ? hash : data.class.new(hash)
     else
       data
     end
   end
  end
end
