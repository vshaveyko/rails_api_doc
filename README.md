
# RailsApiDoc

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_api_doc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_api_doc

## Usage

To display api documentation on route '/api_doc' you need to:

1. config/routes.rb ->
  ```ruby
    mount RailsApiDoc::Engine => '/api_doc'
  ```

2. define request parameters. Example:
  ```ruby
    class AuthorsController < ApplicationController

      has_scope :article_id, :name

      # Define parameters with type and nested options
      parameter :age, type: Integer
      parameter :name, type: String, required: true
      parameter :articles, type: :model, model: Article do
        parameter :title, type: String
        parameter :body, type: String, required: true
        parameter :rating, type: :enum, enum: [1, 2, 3]
        parameter :data, type: :model, model: Datum do
          parameter :creation_date, type: DateTime
          parameter :comment, type: String
        end
      end
      parameter :test, type: String, required: true

    end
  ```

Parameter type may be one of these:

  ```ruby
    ACCEPTED_TYPES = [Bool, String, Integer, Object, Array, DateTime, :enum, :model].freeze
  ```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
