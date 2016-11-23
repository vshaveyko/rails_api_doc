
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

## FEATURES

1) displaying app api
2) Integration with Rabl if it is bundled

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

## TODO's
0.5) type for id reference with model field to display associated model and CONTROLLER in params for linking

1) native DSL for defining response
  ```ruby
    action :show do
      response :age, type: Integer
      response :name, type String
      response :data, type: :model, model: Datum do
        response :creation_date, type: DateTime
        response :comment, type: String
      end
    end
  ```
1.5) native DSL for defining scopes
  ```ruby
    scope :age, desc: 'Filters authors by given age'
  ```
2) dsl for extending response parameters
   ```ruby
      response :data, type: :model, model: Datum do
        extends DataController, action: :show
      end
   ```
3) dsl for extending request parameters
   ```ruby
      parameter :data, type: :model, model: Datum do
        extends DataController, action: :show
      end
   ```
4) ability to split request params to actions(low prior)
5) CRUD for all parameters
6) merging parameters from all sources before display
7) pull everything that's possible to config
## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
