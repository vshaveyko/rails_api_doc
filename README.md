
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

+ displaying application api if used in one of correct ways
+ Integration with Rabl if it is bundled
+ ```ruby resource_params``` method that fill filter incoming params for you

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
## Strong params

You may want to use your defined request api to filter incoming parameters.
Usually we use something like ```ruby params.permit(:name, :age)```, but no more!
With this gem bundled and parameters correctly configured(see Usage block) you can do this:
  ```ruby
    parameter :body, type: :string
    parameter :title, type: :string

    # controller action
    def create
      Comment.create!(resource_params)
    end
  ```

  and if request is `POST '/comments', params: { body: 'Comment body', title: 'Comment title', age: 34 }`

  Comment will be created with: `Comment(body='Comment body', title='Comment title', age=nil)`

## TYPES

Parameter type may be one of these:

  ```ruby
   # Non nested
    :bool - Boolean type, accepts true, false, 'true', 'false'
    :string - basically because every incoming ctrl param is a string it will accept anything beside nested type
    :integer - accepts numbers as string value, and usual numbers. Ex: '5', 5 - correct, 'error' - incorrect
    :array - array of atomic values (integer, strings, etc)
    :datetime - string with some datetime representation accepted by DateTime.parse
    :enum - one of predefined values of enum: option (only atomic types)

   # nested
    :object - usual nested type. comes very handy with rails nested_attributes feature
    :ary_object - array of :object type, rails nested_attributes on has_many
  ```

## TODO's
+ type for id reference with model field to display associated model and CONTROLLER in params for linking

+ native DSL for defining response
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
+ native DSL for defining scopes
```ruby
scope :age, desc: 'Filters authors by given age'
```
+ dsl for extending response parameters
```ruby
  response :data, type: :model, model: Datum do
    extends DataController, action: :show
  end
```
+ dsl for extending request parameters
```ruby
parameter :data, type: :model, model: Datum do
  extends DataController, action: :show
end
```
+ ability to split request params to actions(low prior)
+ CRUD for all parameters
+ merging parameters from all sources before display
+ pull everything that's possible to config

## Development

+ add specs for everything done
+ inline documentation
+ README FAQ on added functionality with examples

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
