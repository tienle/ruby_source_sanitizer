# RubySourceSanitizer

Just simply sanitize a ruby source code by parsing the source into S-Exp (AST).
I used it for filtering out harmful Ruby code while evaluating an external source. Eg. `eval(sanitize(any_ruby_source))`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_source_sanitizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_source_sanitizer

## Usage

Define a sanitizer with your custom rules.

```ruby

class MySanitizer < RubySourceSanitizer
  permit(:block)
  permit(:defn)
  permit(:call)
  permit(:args)
  permit(:return)
  permit(:str)

  # Only allow to call these methods
  def rewrite_call(exp)
    return nil unless [:visit, :root_path].include?(exp[2])
    exp
  end
end

code = <<-RUBY
  def test(a)
    return "foo"
  end

  visit root_path
  click "Button"
RUBY

result = MySanitizer.new.sanitize(code)

puts result

# It will produce this result:
#
# def test(a)
#   return "foo"
# end
#
# visit(root_path)

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ruby_source_sanitizer.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
