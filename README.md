# CommandExtension

Gem will help if you have a lot of commands with delayed calls, for example delayed jobs or sidekiq, and you want them to be executed only after the AR transaction is completed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'command_extension'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install command_extension

## Usage

Here's a basic example of a command

```ruby
class YourCommand
  include CommandExtension::Base
  include CommandExtension::AfterCommit

  after_commit :update_something_by_sidekiq
  
  def execute
    ActiveRecord::Base.transaction do
      ...
      after_commit do
        ...
      end
    end
    
    super
  end
  
  def update_something_by_sidekiq
    ...
  end
end
```

Another example with subcommand, you are sure that emails will be sent only if the transaction is completed

```ruby
class BaseCommand
  include CommandExtension::Base
  include CommandExtension::AfterCommit
end

class CreateOrderCommand < BaseCommand
  def execute
    ActiveRecord::Base.transaction do
      order = Order.create()
      
      after_commit do
        SendEmailToBuyer.call_async(order.user_id)
      end

      subcommand(UpdateUserProfit.new(order)).execute
      
      # if an error occurs then nothing will be sent
      # raise 
    end

    super
  end
end

class UpdateUserProfit < BaseCommand
  
  attr_reader :order
  
  def initialize(order)
    @order = order
    
    super()
  end
  
  def execute
    ActiveRecord::Base.transaction do
      profit = Profit.find_by(user_id: order.seller_id)
      profit.update_something
      
      after_commit do
        SendEmailToSeller.call_async(order.seller_id)
      end
    end
    
    super
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/command_extension. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
