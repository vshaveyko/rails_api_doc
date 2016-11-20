# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
object @author

attributes :age, :name

child @articles => :ivar_articles, partial: 'test/articles/show'

node :custom_node do |author|
  author.title.to_s
end

glue @article do
  attributes :title, :body
end

child articles: :articles_modified do
  attributes :title, :body, :rating

  child data: :data do
    attributes :creation_date, :comment
  end
end
