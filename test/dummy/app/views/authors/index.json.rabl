# frozen_string_literal: true
# author: Vadim Shaveiko <@vshaveyko>
collection @authors

attribute created_at: :init_date

extends 'authors/show'

attributes :age, name: :changed_name
