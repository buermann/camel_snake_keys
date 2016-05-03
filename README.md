# camel_snake_keys

Add recursive with_snake_keys and with_camel_keys to Enumerable without converting everything into a string.

## Documentation

Add gem 'camel_snake_keys' to your gemfile or gem install camel_snake_keys.

Enumerables will be monkey patched the following methods:

with_snake_keys(with_indifferent=false) 
with_camel_keys(with_indifferent=false)

If with_indifference is set to a true value hashes will be returned as ActiveSupport's HashWithIndifferentAccess.

```
require './lib/camel_snake_keys'

{fooBar: "Frob"}.with_snake_keys
=> {:foo_bar=>"Frob"}

[{:foo_bar=>"Frob"}].with_camel_keys
=> [{fooBar: "Frob"}]
```

