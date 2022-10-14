0.1.0 10/14/2022
================

Re-using ActiveSupport::Inflector's camelize and underscore methods converts "::" to "/" and "/" to "::", which might be useful in Rails' internals, but in the context of a Grape API it corrupts the swagger docs.

Implement our own camelize and underscore methods that leave "::" and "/" alone, rather than relying on ActiveSupport.

Replace travis etc. with github actions.

0.0.7 02/08/2022
================

Support Ruby 3+

0.0.6 04/07/2020
===============

### Bug fix

Pass the indifferent access flag down the recursion.

0.0.3 05/11/2016
================

### Features

Preserve any descendent of Hash that accepts a Hash in its initialize method, as with ActiveSupport::HashWithIndifferentAccess and Hashie::Mash

0.0.2 05/11/2016
================

### Features

Preserve Hashie::Mashes.
