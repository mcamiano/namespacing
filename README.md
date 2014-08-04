# Namespacing [![Build Status](https://travis-ci.org/jah2488/namespacing.png?branch=master)](https://travis-ci.org/jah2488/namespacing) [![Code Climate](https://codeclimate.com/github/jah2488/namespacing.png)](https://codeclimate.com/github/jah2488/namespacing) [![Dependency Status](https://gemnasium.com/jah2488/namespacing.png)](https://gemnasium.com/jah2488/namespacing)
[![Gem Version](https://badge.fury.io/rb/namespacing.png)](http://badge.fury.io/rb/namespacing)

# This is a fork of jah2488/namespacing

This fork is here for experimenting. See jah2488's for the authoritative gem.

Changes: 
  - added options hash to ns
  - added `:constants` key to set constants in namespace
  - moved `delim` argument as `:delimiter` key in options hash

# Namespacing
 
Namespacing adds namespaces to Ruby by taking inspiration from how Clojure handles its namespaces.
It is primarly a simplification of the existing module syntax. Great for deeply nested modules or for attempting a more functional approach to writing Ruby code. I wrote [a blog post](http://jah2488.roon.io/adding-namespaces-to-ruby-for-fun-and-practice) about the inspiration and process of creating this code.

## Installation

Add this line to your application's Gemfile:

    gem 'namespacing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install namespacing

## Usage

Simply require the gem and decide the scope you'd like to have it at. To use it in the global scope, you'll want to extend `Object`

```rb
require 'namespacing'

class Object
  include Namespacing
end

ns 'my_app.dojo.util.options' do
  def names
    %w(on off maybe 7 42 tuesday)
  end
end
```
Then this code can be called with: 
```rb
MyApp::Dojo::Util::Options.names 
#=> ['on', 'off', 'maybe', '7', '42', 'tuesday']
```

Option keys can be passed in when defining your namespace:
 (jah2488 recommends against using `_` as that delimiter.)
```rb
ns 'github|repositories|settings', { :delimiter=> '|' } do
  def destroy!
    confirm
  end
end

Github::Repositories::Settings.destroy!
```



## Gotchas

There is at least one known and unexpected side effect. 

__Defining constants inside the `ns` block does not work as expected__. 
Any constants set will be at the top level namespace.
```rb
ns 'rails.active_support.version' do
  VERSION = '1.0.0'
end

Rails::ActiveSupport::Version #=> NameError: uninitialized constant Kernel::Rails::ActiveSupport::Version::VERSION
VERSION #=> '1.0.0'
```

There are currently three ways to define constants in the proper scoping to avoid this issue:

1. __Define the full scope of the constant__
```rb
ns 'rails.active.version' do
  Rails::Active::Version::MAJOR = 1
end

Rails::Active::Version::MAJOR #=> 1
```

2. __Use `const_set`__
```rb
ns 'rails.support.version' do
  const_set(:MAJOR, 1)
end

Rails::Support::Version::MAJOR #=> 1
```

3. __Use the `:constants` option key__
```rb
ns 'rails.support.version', {:constants=>{ :MAJOR=>1 }} do
end

Rails::Support::Version::MAJOR #=> 1
```

To access a constant inside the do block requires one of the forms 
`self::CONSTNAME`; `const_get('CONSTNAME')`; or `Name::Space::ToConst::CONSTNAME`

I (mcamiano) think that using `self::` or the full module path ensures
that only the precise constant is picked up. The `const_get` method may reach 
back to the global scope. 

## Contributing

1. Fork it ( http://github.com/<my-github-username>/namespacing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
