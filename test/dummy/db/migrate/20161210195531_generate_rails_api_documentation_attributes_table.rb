class GenerateRailsApiDocumentationAttributesTable < ActiveRecord::Migration[5.0]

  def change
    create_table :rails_api_doc_api_data do |t|
      t.integer :api_type

      t.string :action_type
      t.string :api_action
      t.string :type
      t.string :name
      t.string :special
      t.string :desc

      t.text :nesting
    end
  end

end
