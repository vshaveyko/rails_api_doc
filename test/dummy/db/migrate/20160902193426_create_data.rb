class CreateData < ActiveRecord::Migration[5.0]
  def change
    create_table :data do |t|
      t.datetime :creation_date
      t.string :comment

      t.timestamps
    end
  end
end
