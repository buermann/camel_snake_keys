# camel_snake_keys

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Coverage Status][CS img]][Coverage Status]

[Gem Version]: https://rubygems.org/gems/camel_snake_keys
[Build Status]: https://travis-ci.org/buermann/camel_snake_keys
[travis pull requests]: https://travis-ci.org/buermann/camel_snake_keys/pull_requests
[Coverage Status]: https://coveralls.io/r/buermann/camel_snake_keys

[GV img]: https://badge.fury.io/rb/camel_snake_keys.png
[BS img]: https://travis-ci.org/buermann/camel_snake_keys.png
[CS img]: https://coveralls.io/repos/buermann/camel_snake_keys/badge.png?branch=master


Add recursive with_snake_keys and with_camel_keys refinements to Array and Hash. Preserve strings and symbols and treat hash descendents such as ActiveSupport::HashWithIndifferentAccess and Hashie::Mash agnostically.

## Documentation

Add `gem 'camel_snake_keys'` to your Gemfile or gem install camel_snake_keys. Where you want to add `with_snake_keys` and `with_camel_keys` to your objects invoke `using CamelSnakeKeys`, or invoke the class methods, `CamelSnakeKeys.camel_keys(object, with_indifference)` and `CamelSnakeKeys.snake_keys(object, with_indifference)`.

If with_indifference is set to a true value hashes will be returned as ActiveSupport's HashWithIndifferentAccess.

```
require 'camel_snake_keys'

using CamelSnakeKeys

{fooBar: "Frob"}.with_snake_keys
=> {:foo_bar=>"Frob"}

[{:foo_bar=>"Frob"}].with_camel_keys
=> [{fooBar: "Frob"}]
```

