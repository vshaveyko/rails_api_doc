
# RailsApiDoc

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_api_documentation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_api_documentation

## Features

+ Displaying application api if used in one of the correct ways.
  ![alt tag](https://raw.githubusercontent.com/vshaveyko/rails_api_doc/master/preview.png)
+ Integration with Rabl if it is bundled.
+ `strong_params` method that will filter incoming params for you.

## Usage

To display api documentation on route '/api_doc' you need to:

1. config/application.rb ->
```ruby
require 'rails_api_doc'
```

2. config/routes.rb ->
```ruby
mount RailsApiDoc::Engine => '/api_doc'
```

3. define request parameters. Example:
```ruby
class AuthorsController < ApplicationController

  has_scope :article_id, :name

  # Define parameters with type and nested options
  # Article and Datum are usual ActiveRecord models
  parameter :age, type: :integer
  parameter :name, type: :string, required: true
  parameter :articles_attributes, type: :ary_object, model: 'Article' do
    parameter :title, type: :string
    parameter :body, type: :string, required: true
    parameter :rating, type: :enum, enum: [1, 2, 3]
    parameter :data_attributes, type: :object, model: 'Datum' do
      parameter :creation_date, type: :datetime
      parameter :comment, type: :string
    end
  end
  parameter :test, type: :string, required: true

  parameter({
    articles_attributes: { model: 'Article', type: :ary_object },
    data_attributes: { model: 'Datum' },
    comments_attributes: { model: 'Comment', type: :ary_object }
  }, type: :object) do
    parameter :id
    parameter :name
  end

end
```

4. go to localhost:3000/api_doc

## Strong params

You may want to use your defined request api to filter incoming parameters.
Usually we use something like `params.permit(:name, :age)`, but no more!
With this gem bundled you can do this:

```ruby
parameter :body, type: :string
parameter :title, type: :string

# controller action
def create
  Comment.create!(strong_params)
end
```

and if request is `POST '/comments', params: { body: 'Comment body', title: 'Comment title', age: 34 }`

Comment will be created with: `Comment(body='Comment body', title='Comment title', age=nil)`

## Value

You can pass optional value argument to every parameter:

```ruby
parameter :val, type: :integer, value: -> (request_value) { 5 }
```

on every matching request value in this field will be overriden by value returned by proc.

value field expecting anything that will respond to `:call` and can accept one argument(param value from request)

you should expect that value passed can be `nil`

This can be used to force values on some fields, or modify values passed to request in some ways.

E.g. you want to force current_user_id on model creation instead of passing it from frontend.

## Enum

When you defined parameter type as `:enum` you can pass `enum:` option. This will filter parameter by values provided.

E.g.:

```ruby
parameter :rating, type: :enum, enum: [1, 2, 3]
```

All enum values are parsed as strings, since controller params are always strings. Still you may write them as you want. Every member of enum array will be replaced with `&:to_s` version.

## Group common blocks

You can define parameters that have common fields this way:

```ruby
parameter({
  articles_attributes: { model: 'Article', type: :ary_object },
  data_attributes: { model: 'Datum' },
  comments_attributes: { model: 'Comment', type: :ary_object }
}, type: :object) do
  parameter :id
  parameter :name
end
```

Pass common values as last optional arguments and uniq definitions as hash value.
All nesting parameters are applied to elements in blocks.

Something with same type can be defined like this:

```ruby
parameter :name, :desc, type: :string
```

## Types

Parameter type may be one of these:

```ruby
# Non nested
:bool - Boolean type, accepts true, false, 'true', 'false'
:string - will accept anything beside nested type
:integer - accepts numbers as string value, and usual numbers
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
