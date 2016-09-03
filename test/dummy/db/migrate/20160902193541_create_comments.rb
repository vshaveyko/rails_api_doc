class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :article, foreign_key: true
      t.string :body
      t.integer :rating

      t.timestamps
    end
  end
end
