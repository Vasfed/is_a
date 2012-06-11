# IsA

A small library of missing ruby methods for introspection. See Usage.

## Installation

Add this line to your application's Gemfile:

    gem 'is_a'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install is_a

## Usage

```ruby
require 'is_a'

obj = BasicObject.new
begin
  obj.class
rescue
  puts "Yep, BasicObject will not tell you it's class"
  cls = IsA.class_of(obj)
  puts "But IsA will. It's #{cls}"
end

IsA.object?(obj) # => false
IsA.object?("anything that is derived from Object") # => true

 #Also on 1.9.2 there's no way of getting object_id of BasicObject, here it is:
id = IsA.id_of(obj) # or alias ObjectSpace._ref2id(obj)
ObjectSpace._id2ref(id) == obj # => true
 #For 1.9.3 use BasicObject#__id__
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
