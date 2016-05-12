# camel_snake_keys

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Coverage Status][CS img]][Coverage Status]

[Gem Version]: https://rubygems.org/gems/camel_snake_keys
[Build Status]: https://travis-ci.org/buermann/camel_snake_keys
[travis pull requests]: https://travis-ci.org/buermann/camel_snake_keys/pull_requests
[Dependency Status]: https://gemnasium.com/buermann/camel_snake_keys
[Coverage Status]: https://coveralls.io/r/buermann/camel_snake_keys

[GV img]: https://badge.fury.io/rb/camel_snake_keys.png
[BS img]: https://travis-ci.org/buermann/camel_snake_keys.png
[DS img]: https://gemnasium.com/buermann/camel_snake_keys.png
[CS img]: https://coveralls.io/repos/buermann/camel_snake_keys/badge.png?branch=master


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

