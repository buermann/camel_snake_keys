1.0.0 01/31/2024
================

Test against Ruby 3.3.0.

Don't let integer hash keys unleashed the bees.

Fix an introduced bug that produces leading underscores when snaking PascalCase.

0.1.0 10/14/2022
================

ActiveSupport::Inflector's camelize and underscore methods convert "::" to "/" and "/" to "::", which might be useful in Rails' internals, but in the context of a Grape API it corrupts the swagger docs' "paths" objects.

Implement our own camel and snake case methods that leave "::" and "/" unmolested, rather than relying on ActiveSupport, in which case we'll drop that dependency altogether by removing the (trivially re-implemented) indifferent access functionality.

We are not re-implmenting ActiveSupport's acronym inflections. Yet.

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
