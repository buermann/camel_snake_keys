# camel_snake_keys

[![Gem Version][GV img]][Gem Version]
[Gem Version]: https://rubygems.org/gems/camel_snake_keys

Add recursive with_snake_keys and with_camel_keys refinements to Array and Hash. Preserve strings and symbols and treat hash descendents such as ActiveSupport::HashWithIndifferentAccess and Hashie::Mash agnostically.

## Documentation

Add `gem 'camel_snake_keys'` to your Gemfile or "gem install camel_snake_keys".

Where you want to add `with_snake_keys` and `with_camel_keys` to your objects invoke `using CamelSnakeKeys`, or invoke the class methods, `CamelSnakeKeys.camel_keys(object)` and `CamelSnakeKeys.snake_keys(object)`.

```
require 'camel_snake_keys'

using CamelSnakeKeys

{fooBar: "Frob"}.with_snake_keys
=> {:foo_bar=>"Frob"}

[{:foo_bar=>"Frob"}].with_camel_keys
=> [{fooBar: "Frob"}]
```

