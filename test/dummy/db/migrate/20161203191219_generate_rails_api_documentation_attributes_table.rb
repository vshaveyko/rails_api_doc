class GenerateRailsApiDocumentationAttributesTable < ActiveRecord::Migration[5.0]

  def change
    create_table :rails_api_doc_api_datum do |t|
      t.string :api_type
      t.string :type
      t.string :name
      t.string :special
      t.string :desc

      t.text :nesting
    end
  end

end
