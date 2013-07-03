# IsA

A small library of missing ruby methods for introspection. See Usage.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'is_a'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install is_a

## Usage

### BasicObject
If you got an object via `_id2ref` or from similar place - do not rush to duck-typing, it may be a BasicObject and not respond to `respond_to?`. IsA aims in handling such cases.

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

### Fast single line from caller

Ruby's `caller` is handy, but sometimes you do not need the whole array of strings it allocates generates on each call.

`IsA.caller_line` (also global `caller_line`) is a lot faster and does not mess your heap that lot (allocates just the result string, meaning fewer GC):

```ruby
require 'is_a'
require 'benchmark'
n = 10000
Benchmark.bm(11) do |x|
  x.report("caller[1]") { n.times { caller[1] } }
  x.report("caller_line") { n.times { caller_line(1) } }
end
```

Results:

```
                          user     system      total        real
caller[1]             1.760000   0.040000   1.800000 (  1.802799)
caller_line           0.080000   0.000000   0.080000 (  0.089649)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
