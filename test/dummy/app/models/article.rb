class Article < ApplicationRecord

  belongs_to :author
  belongs_to :data

  has_many :comments

end
