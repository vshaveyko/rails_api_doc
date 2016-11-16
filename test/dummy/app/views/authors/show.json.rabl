object @author

attributes :age, :name

child articles: :articles do
  attributes :title, :body, :rating

  child data: :data do
    attributes :creation_date, :comment
  end
end
